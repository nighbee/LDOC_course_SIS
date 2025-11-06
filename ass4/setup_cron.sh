#!/bin/bash
set -e
chmod +x  cleanlogs.sh

(crontab -l 2>/dev/null; echo "0 * * * * $(pwd)/cleanup_logs.sh") | crontab -
crontab -l
echo "Cron installed"
