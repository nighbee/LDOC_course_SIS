#!/bin/bash

set -e  # Exit on error

echo "package installation" 
sudo apt update && sudo apt upgrade -y


sudo apt install -y docker.io docker-compose-plugin postgresql postgresql-contrib openssh-server ufw
sudo usermod -aG docker $USER
newgrp docker
sudo systemctl enable --now docker postgresql ssh


sudo apt install -y ufw


curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

cd /app/ESG

echo "Installing Frontend packages..."
cd frontend
npm init -y
npm install react@18 react-dom@18 tailwindcss@3
cd ..


echo "Installing Backend Go modules..."
cd backend
go mod init esg-backend
go get github.com/gofiber/fiber/v2@v2.52.0
go get github.com/golang-jwt/jwt/v5@v5.2.0
go get github.com/joho/godotenv@v1.5.1
go get golang.org/x/crypto@v0.17.0
go get gorm.io/gorm@v1.25.5
go get gorm.io/driver/postgres@v1.5.4
go mod tidy  # Pulls indirect deps (e.g., pgx, uuid, etc.)
cd ..

echo "complete"
echo "Verify:"
echo "- Docker: docker --version"
echo "- Node.js: node --version"
echo "- Go: go version"
echo "- Frontend: cd /app/esgapp/frontend && npm list"
echo "- Backend: cd /app/esgapp/backend && go list -m all"
echo "Run smoke tests next: ./smoke_test_infra.sh"
