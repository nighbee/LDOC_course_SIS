#!/bin/bash

set -e  # Exit on error

echo "installation"

# Step 1: OS/Infra Packages (apt) - Install only, no update
echo "Installing OS/Infra packages..."
sudo apt install -y docker.io docker-compose-plugin postgresql postgresql-contrib openssh-server ufw
sudo usermod -aG docker $USER
newgrp docker
sudo systemctl enable --now docker postgresql ssh


sudo apt install -y ufw --no-install-recommends

echo "Installing Node.js"
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs --no-install-recommends

echo "Installing Go "
wget -q https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
export PATH=$PATH:/usr/local/go/bin  # Apply immediately
go version

sudo mkdir -p /app/esgapp/{frontend,backend}
cd /app/esgapp

echo "Installing Frontend packages..."
cd frontend
npm init -y >/dev/null
npm install react@18 react-dom@18 tailwindcss@3 --silent
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
go mod tidy
cd ..

echo "=== Installation Complete (No System Update) ==="
echo "Verify with:"
echo "  docker --version"
echo "  node --version"
echo "  go version"
echo "  cd /app/esgapp/frontend && npm list"
echo "  cd /app/esgapp/backend && go list -m all"
echo "Next: Run ./smoke_test_infra.sh and ./smoketestapp.sh"
