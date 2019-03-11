#!/usr/bin/env PYTHONIOENCODING=UTF-8 /usr/local/bin/python3
# encoding: utf-8
import os
import psutil
import re
import subprocess
import sys

def is_sync_running():
    for proc in psutil.process_iter():
        try:
            if proc.name().lower() in ["notmuch", "mbsync"]:
                return True
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass

    return False

if is_sync_running():
    print("waiting for sync... | color=gray")
    sys.exit(0)

script_dir = os.path.join(os.path.dirname(os.path.abspath(sys.argv[0])), "../bin")

unread_mails = subprocess.check_output("/usr/local/bin/notmuch tag -inbox -new -unread +sent folder:sent AND tag:unread AND tag:new".split())
unread_mails = subprocess.check_output("/usr/local/bin/notmuch search tag:unread".split())

mails = list(filter(lambda x: x.strip(), unread_mails.decode("utf-8").split("\n")))
count = len(mails)
if count:
    print(":incoming_envelope: {count} threads | color=red".format(count=count))
else:
    print("no unread mail | color=#707070")

print("---")

pattern = re.compile(r'^(?P<thread>\S*) +\S+ +\S+ +\S+ +(?P<people>.*?); +(?P<subject>.*?)( +\([^)]*\))?$')
for m in mails:
    mo = pattern.match(m)
    if not mo:
        print("didn't match: " + m)
        exit(-1)

    thread = mo.group("thread")
    subject = mo.group("subject")[:64].replace('|', ':')
    people = " ".join(mo.group("people").split()[:2]).replace('|', ',').strip(",")

    print(("{subject} - {people} | color=green terminal=false " +
           "bash={script_dir}/open-mail-in-emacs-osx param1={thread}")
            .format(thread=thread, subject=subject, people=people, script_dir=script_dir))
