#!/bin/bash
set -e


DOCKER_USER="ztktsn"  
BACKEND_IMG="$DOCKER_USER/esg-backend:v1.0"
FRONTEND_IMG="$DOCKER_USER/esg-frontend:v1.0"
sudo tee /etc/esg-backend.env > /dev/null <<EOF
DB_HOST=aws-1-us-east-2.pooler.supabase.com
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
