#!/bin/bash
set -e

BACKUP_DIR="/backups"
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p "$BACKUP_DIR"

source /etc/esg-backend.env

pg_dump "postgres://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}?sslmode=${DB_SSLMODE}" \
  > "$BACKUP_DIR/esg_backup_$DATE.sql"

find "$BACKUP_DIR" -name "esg_backup_*.sql" -mtime +7 -delete

echo "Backup completed: $BACKUP_DIR/esg_backup_$DATE.sql"
