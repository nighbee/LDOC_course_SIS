#!/bin/bash
# Script to filter journal logs by service name
if [ -z "$1" ]; then
    echo "Usage: $0 <service_name>"
    exit 1
fi

echo "Fetching logs for service: $1"
journalctl -u "$1" --no-pager
