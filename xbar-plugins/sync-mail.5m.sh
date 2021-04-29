#!/bin/bash

if test -f "/tmp/silence-mail"; then
    echo "silenced | color=#707070"
    exit 0
fi

script_path=$(readlink "$0")
if [ -z "$script_path" ]; then
    script_path="$0"
fi

cd "$(dirname "$script_path")"

../bin/sync-mail
