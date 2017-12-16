#!/usr/bin/env python3
import subprocess


def get_password(host, port, account):
    try:
        data = subprocess.check_output(
            r"/usr/local/bin/gpg -q --no-tty --batch -d ~/.authinfo.gpg",
            shell=True).decode('utf-8')
    except subprocess.CalledProcessError:
        data = ""

    for line in data.split("\n"):
        line = line.strip()
        words = line.split()
        if len(words) != 8:
            continue

        if words[1] == host and \
           words[3] == account and \
           words[5] == str(port):
            return words[7]

    return ""
