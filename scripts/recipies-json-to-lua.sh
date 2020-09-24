#!/usr/bin/env bash

if [[ "$1" == "" ]]; then
    echo "need to specify FILE arg"; exit 1
fi
if [[ ! -f "$1" ]]; then
    echo "specified FILE does not exist"; exit 1
fi

KEY='\(.name | ascii_downcase | gsub("\""; "") | gsub("-"; "") | gsub(" "; "_") | gsub("__"; "_"))'
FILTER='.[] | "'$KEY' = new(\"\(.name | gsub("\""; "\\\""))\", \"\(.type)\", \(.tier), \(.mass), \(.volume))"'

cat $1 | jq -r "$FILTER"
