#!/bin/bash
set -e


DOCKER_USER="ztktsn"  
BACKEND_IMG="$DOCKER_USER/esg-backend:v1.0"
FRONTEND_IMG="$DOCKER_USER/esg-frontend:v1.0"
sudo tee /etc/esg-backend.env > /dev/null <<EOF
DB_HOST=aws-1-us-east-2.pooler.supabase.com#!/bin/bash
set -e

DOCKER_USER="ztktsn"        
BACKEND_IMG="$DOCKER_USER/esg-backend:v1.0"
FRONTEND_IMG="$DOCKER_USER/esg-frontend:v1.0"
PROJECT_DIR="/home/almaz/ESG"
ENV_FILE="$PROJECT_DIR/.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "ERROR: $ENV_FILE not found!"
  exit 1
fi

sudo tee /etc/systemd/system/esg-backend.service > /dev/null <<EOF
[Unit]
Description=ESG Backend (Supabase)
After=docker.service network-online.target
Requires=docker.service
Wants=network-online.target

[Service]
Type=simple
TimeoutStartSec=120
Restart=always
RestartSec=15
ExecStartPre=-/usr/bin/docker stop esg-backend
ExecStartPre=-/usr/bin/docker rm esg-backend
ExecStartPre=/usr/bin/docker pull $BACKEND_IMG
ExecStart=/usr/bin/docker run --name esg-backend \
  -p 8080:8080 \
  --env-file $ENV_FILE \
  --restart unless-stopped \
  --health-cmd="wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1" \
  --health-interval=10s \
  --health-timeout=5s \
  --health-retries=6 \
  $BACKEND_IMG
ExecStop=/usr/bin/docker stop esg-backend

[Install]
WantedBy=multi-user.target
EOF

# === 3. Frontend service ===
sudo tee /etc/systemd/system/esg-frontend.service > /dev/null <<EOF
[Unit]
Description=ESG Frontend
After=docker.service esg-backend.service
Requires=docker.service esg-backend.service

[Service]
Type=simple
TimeoutStartSec=60
Restart=always
RestartSec=10
ExecStartPre=-/usr/bin/docker stop esg-frontend
ExecStartPre=-/usr/bin/docker rm esg-frontend
ExecStartPre=/usr/bin/docker pull $FRONTEND_IMG
ExecStart=/usr/bin/docker run --name esg-frontend \
  -p 3000:80 \
  --env VITE_API_BASE_URL=http://localhost:8080/api \
  --restart unless-stopped \
  $FRONTEND_IMG
ExecStop=/usr/bin/docker stop esg-frontend

[Install]
WantedBy=multi-user.target
EOF


sudo systemctl daemon-reload
sudo systemctl enable esg-backend.service esg-frontend.service
sudo systemctl restart esg-backend.service
sudo systemctl restart esg-frontend.service

sleep 12
echo "=== BACKEND ==="
sudo systemctl status esg-backend.service --no-pager -l
echo "=== FRONTEND ==="
sudo systemctl status esg-frontend.service --no-pager -l

echo ""
echo "Test:"
echo "  curl http://localhost:8080/health"
echo "  open http://localhost:3000"
DB_PORT=5432
DB_NAME=postgres
DB_USER=postgres.fmynwlltkssjwtsliwlu
DB_PASSWORD=YOUR_SUPABASE_PASSWORD_HERE
DB_SSLMODE=require
JWT_SECRET=WMfWqTlnzAySA1r+gk9Kc7W8HQSJKThyxEYGHIfYI0NCUjB3c4jU8vbchHxH9E1UDHo92iLsNeF09AVcJsTTEg==
PORT=8080
LOG_LEVEL=info
ENVIRONMENT=production
EOF


sudo tee /etc/systemd/system/esg-backend.service > /dev/null <<EOF
[Unit]
Description=ESG Scoring Backend (Supabase)
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Restart=always
RestartSec=10
ExecStartPre=-/usr/bin/docker stop esg-backend
ExecStartPre=-/usr/bin/docker rm esg-backend
ExecStartPre=/usr/bin/docker pull $BACKEND_IMG
ExecStart=/usr/bin/docker run --name esg-backend -p 8080:8080 --env-file /etc/esg-backend.env --restart unless-stopped $BACKEND_IMG
ExecStop=/usr/bin/docker stop esg-backend

[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/systemd/system/esg-frontend.service > /dev/null <<EOF
[Unit]
Description=ESG Scoring Frontend
After=docker.service esg-backend.service
Requires=docker.service esg-backend.service

[Service]
TimeoutStartSec=0
Restart=always
RestartSec=10
ExecStartPre=-/usr/bin/docker stop esg-frontend
ExecStartPre=-/usr/bin/docker rm esg-frontend
ExecStartPre=/usr/bin/docker pull $FRONTEND_IMG
ExecStart=/usr/bin/docker run --name esg-frontend -p 3000:80 --restart unless-stopped $FRONTEND_IMG
ExecStop=/usr/bin/docker stop esg-frontend

[Install]
WantedBy=multi-user.target
EOF


sudo systemctl daemon-reload
sudo systemctl enable esg-backend.service esg-frontend.service
sudo systemctl restart esg-backend.service esg-frontend.service

echo "=== ESG Backend ==="
sudo systemctl status esg-backend.service --no-pager
echo "=== ESG Frontend ==="
sudo systemctl status esg-frontend.service --no-pager

echo "Setup complete! Access:"
echo "  Frontend: http://localhost:3000"
echo "  Backend Health: curl http://localhost:8080/health"
