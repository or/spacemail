#!/usr/bin/env python3
import argparse
import os.path
import re
import shlex
import subprocess

DEFAULT_ADDRESS_CACHE_FILE = '~/.cache-address-completion'

EMAIL = re.compile(r'[^< ]+@[^>]+')

def add_line(address_map, line):
    line = line.strip()

    if not line:
        return

    email = EMAIL.findall(line)
    if len(email) != 1:
        return

    email = email[0]

    if email not in address_map:
        address_map[email] = line


def query_notmuch(address_map, command):
    results = subprocess.check_output(shlex.split(command))

    for line in results.decode('utf-8').split('\n'):
        add_line(address_map, line)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-o', '--output', default=DEFAULT_ADDRESS_CACHE_FILE, required=False)
    parser.add_argument('condition', nargs='*')

    args = parser.parse_args()

    args.condition = ' '.join(args.condition).strip()
    if not args.condition:
        args.condition = "'*'"


    notmuch_path = subprocess.check_output("which notmuch", shell=True).decode('utf-8').strip()

    address_map = {}

    query_notmuch(
        address_map,
        "{} address --output=sender --deduplicate=address {}".format(notmuch_path, args.condition))

    query_notmuch(
        address_map,
        "{} address --output=recipients --deduplicate=address {}".format(notmuch_path, args.condition))

    with open(os.path.expanduser(args.output), 'w') as f:
        for line in sorted(address_map.values()):
            f.write(line + '\n')
