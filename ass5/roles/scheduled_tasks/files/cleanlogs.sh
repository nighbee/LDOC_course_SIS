#!/bin/bash
set -e

LOG_DIR="/var/log/esgapp"
sudo mkdir -p "$LOG_DIR"

sudo docker logs esg-backend --tail 2000 2>&1 | sudo tee "$LOG_DIR/backend.log" > /dev/null
sudo docker logs esg-frontend --tail 2000 2>&1 | sudo tee "$LOG_DIR/frontend.log" > /dev/null

sudo find "$LOG_DIR" -name "*.log" -mtime +3 -type f -delete

echo "Logs rotated: $(date)"
