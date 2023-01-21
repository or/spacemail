#!/bin/bash

script_path=$(readlink "$0")
if [ -z "$script_path" ]; then
    script_path="$0"
fi

cd "$(dirname "$script_path")"


if test -f "/tmp/silence-mail"; then
    ../bin/sync-mail > /dev/null
    echo "silenced | color=#707070"
    exit 0
else
    ../bin/sync-mail
fi
