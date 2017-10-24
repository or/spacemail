#!/bin/zsh

values=$(notmuch search --output=messages --format=text tag:noise and date:1d.. | xargs notmuch show --format=json | jq '.[][0][0].headers.Date' | collect_buckets.py | tail -n 12)
echo $values | awk '{print $3}' | spark
echo "---"
echo $values | awk '{print $1 " " $2 ":00" "   " $3}'
