#!/usr/bin/env bash
set -euo pipefail
if [ "$EUID" -ne 0 ]; then
  echo "Run as root"
  exit 1
fi

#Admins: full sudo 
cat > /etc/sudoers.d/esg_admins <<'EOF'
# esg admins - full sudo 
%esg_admins ALL=(ALL) ALL
EOF
chmod 440 /etc/sudoers.d/esg_admins

#  Automation: allow docker-compose & restart services without password 
cat > /etc/sudoers.d/esg_automation <<'EOF'
# automation user: only allowed to run specific maintenance commands without password
%automation ALL=(root) NOPASSWD: /usr/bin/docker-compose -f /srv/esg/docker-compose.yml up, \
/usr/bin/docker-compose -f /srv/esg/docker-compose.yml down, \
/bin/systemctl restart esg_backend.service, \
/bin/systemctl status esg_backend.service
EOF
chmod 440 /etc/sudoers.d/esg_automation

# Validate
visudo -c
echo "Sudoers files created."

