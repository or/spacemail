#!/bin/bash

eval "$(/opt/homebrew/bin/brew shellenv)"
export PYENV_ROOT="$HOME/.pyenv"
eval "$(pyenv init --path)"

script_path=$(readlink "$0")
if [ -z "$script_path" ]; then
    script_path="$0"
fi

cd "$(dirname "$script_path")"
cd ../bin

./notmuch-mail-count.py
