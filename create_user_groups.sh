#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Run as root: sudo $0"
  exit 1
fi

groups=(esg_admins esg_auditors automation managers students devs)
for g in "${groups[@]}"; do
  if ! getent group "$g" >/dev/null; then
    groupadd "$g"
    echo "group created: $g"
  else
    echo "group exists: $g"
  fi
done


# Human admin (example: student should create his admin user or use own account)
if ! id -u almaz_admin >/dev/null 2>&1; then
  useradd -m -s /bin/bash -G esg_admins almaz_admin
  echo "Created human admin almaz_admin (please set password with: passwd almaz_admin)"
fi

# Example human accounts for testing (students/managers)
for u in manager1 student1; do
  if ! id -u "$u" >/dev/null 2>&1; then
    useradd -m -s /bin/bash -G managers,students "$u" || true
    echo "Created test user: $u (set password with: passwd $u)"
  fi
done

# Service/system users (no interactive login)
system_users=(
  "postgres"        # if postgres exists, skip; normally exists by package
  "esg_backend"
  "esg_frontend"
  "esg_automation"
)
for su in "${system_users[@]}"; do
  if ! id -u "$su" >/dev/null 2>&1; then
    useradd --system --no-create-home --shell /usr/sbin/nologin "$su" || true
    echo "Created system user: $su"
  else
    echo "System user exists: $su"
  fi
done

# Add service accounts to groups as needed
usermod -aG esg_admins esg_automation 2>/dev/null || true
usermod -aG devs esg_backend 2>/dev/null || true

echo "Done creating groups and users."

