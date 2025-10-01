#!/usr/bin/env bash
set -euo pipefail
if [ "$EUID" -ne 0 ]; then
  echo "Run as root"
  exit 1
fi

AUTH_USER=esg_automation
KEYDIR="/home/$AUTH_USER/.ssh"
KEY="$KEYDIR/id_ed25519"

# create home for system user 
if [ ! -d "/home/$AUTH_USER" ]; then
  mkdir -p "/home/$AUTH_USER"
  chown "$AUTH_USER":"$AUTH_USER" "/home/$AUTH_USER"
fi

mkdir -p "$KEYDIR"
chown "$AUTH_USER":"$AUTH_USER" "$KEYDIR"
chmod 700 "$KEYDIR"

# generate key as that user
sudo -u "$AUTH_USER" ssh-keygen -t ed25519 -f "$KEY" -N "" -C "$AUTH_USER@$(hostname)" || true
chown "$AUTH_USER":"$AUTH_USER" "$KEY" "$KEY.pub"
chmod 600 "$KEY"
chmod 644 "$KEY.pub"

echo "SSH key generated for $AUTH_USER: $KEY"
echo "To copy key to remote host: sudo -u $AUTH_USER ssh-copy-id -i $KEY.pub <user>@<host>"

