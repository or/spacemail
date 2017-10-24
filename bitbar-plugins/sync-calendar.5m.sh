#!/bin/zsh

script_path=$(readlink "$0")
if [ -z "$script_path" ]; then
    script_path="$0"
fi

cd "$(dirname "$script_path")"

../bin/sync-calendar
