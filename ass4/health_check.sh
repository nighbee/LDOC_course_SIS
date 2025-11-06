#!/bin/bash


CONTAINER_NAME="esg-backend"
LOG_FILE="/var/log/esg-health.log"

if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "$(date): $CONTAINER_NAME is running" >> "$LOG_FILE"
else
    echo "$(date): $CONTAINER_NAME is NOT running. Restarting service..." >> "$LOG_FILE"
    systemctl restart esg-backend.service
fi
