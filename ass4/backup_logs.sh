#!/bin/bash


BACKUP_DIR="/var/log/esg-backup"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p "$BACKUP_DIR"
docker logs esg-backend > "$BACKUP_DIR/esg-backend-$DATE.log" 2>&1

echo "$(date): Backup created at $BACKUP_DIR/esg-backend-$DATE.log" >> "$BACKUP_DIR/backup_status.log"
