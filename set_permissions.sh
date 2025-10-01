#!/usr/bin/env bash
set -euo pipefail
if [ "$EUID" -ne 0 ]; then
  echo "Run as root"
  exit 1
fi

mkdir -p /srv/esg/frontend /srv/esg/backend /var/log/esgapp /tmp/esgapp

chown -R esg_frontend:esg_admins /srv/esg/frontend
chown -R esg_backend:esg_admins /srv/esg/backend
chown -R esg_backend:esg_admins /var/log/esgapp
chown -R postgres:postgres /var/lib/postgresql/data || true

chmod 750 /srv/esg/frontend
chmod 2750 /srv/esg/backend   # setgid: все файлы наследуют группу esg_admins
chmod 750 /var/log/esgapp
chmod 700 /tmp/esgapp

chmod 750 /var/log/esgapp
chmod +t /tmp/esgapp

echo "Permissions set."

ls -ld /srv/esg /srv/esg/backend /var/log/esgapp || true

