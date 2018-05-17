#!/usr/bin/env python3
import os.path
import sys

from generate_addresses import DEFAULT_ADDRESS_CACHE_FILE

if __name__ == '__main__':
    keyword = sys.argv[1].lower()

    for line in open(os.path.expanduser(DEFAULT_ADDRESS_CACHE_FILE)):
        line = line.strip()
        if keyword in line.lower():
            print(line)
