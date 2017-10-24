#!/usr/bin/env PYTHONIOENCODING=UTF-8 /usr/local/bin/python3
# encoding: utf-8
import os
import re
import subprocess
import sys

def is_notmuch_running():
    output = subprocess.check_output(["ps", "-x"])
    for line in output.decode("utf-8").split("\n"):
        words = line.split()

        if len(words) <= 3:
            continue

        if words[3] == "notmuch":
            return True

        if len(words) <= 4:
            continue

        if words[4].endswith("offlineimap.py"):
            return True

    return False

if is_notmuch_running():
    print("waiting for sync... | color=gray")
    sys.exit(0)

script_dir = os.path.join(os.path.dirname(os.path.abspath(sys.argv[0])), "../bin")

unread_mails = subprocess.check_output("/usr/local/bin/notmuch tag -inbox -new -unread +sent folder:sent AND tag:unread AND tag:new".split())
unread_mails = subprocess.check_output("/usr/local/bin/notmuch search tag:unread".split())

mails = list(filter(lambda x: x.strip(), unread_mails.decode("utf-8").split("\n")))
count = len(mails)
if count:
    print(":incoming_envelope: {count} unread | color=red".format(count=count))
else:
    print("no unread mails | color=#707070")

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
