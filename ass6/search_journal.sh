#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <search_term>"
    exit 1
fi

echo "Searching journal for: $1"
journalctl | grep "$1"
