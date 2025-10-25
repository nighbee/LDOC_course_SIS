#!/bin/bash

set -e


echo "Installing Infrastructure pack"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y \
    docker.io \
    docker-compose-plugin \
    postgresql \
    postgresql-contrib \
    openssh-server \
    ufw \
    curl \
    wget

echo "adding $user into a docker group"
sudo usermod -aG docker ${USER}

sudo systemctl enable --now docker
sudo systemctl enable --now postgresql
sudo systemctl enable --now ssh

echo "Installing Node.js"
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "Installing Go "
GO_VERSION="1.21.5"
GO_ARCH="amd64"
wget -q "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" -O /tmp/go.tar.gz
sudo tar -C /usr/local -xzf /tmp/go.tar.gz
rm /tmp/go.tar.gz

echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
export PATH=$PATH:/usr/local/go/bin

echo "Setting up application directories and permissions"
sudo mkdir -p /app/esgapp/{frontend,backend}
sudo chown -R ${USER}:${USER} /app

echo "Installing Frontend"
cd /app/esgapp/frontend
npm init -y > /dev/null
npm install react@18 react-dom@18 tailwindcss@3 --silent

echo "Installing Backend Go modules"
cd /app/esgapp/backend
go mod init esg-backend
go get github.com/gofiber/fiber/v2@v2.52.0
go get github.com/golang-jwt/jwt/v5@v5.2.0
go get github.com/joho/godotenv@v1.5.1
go get golang.org/x/crypto@v0.17.0
go get gorm.io/gorm@v1.25.5
go get gorm.io/driver/postgres@v1.5.4
go mod tidy

echo "Installation Complete"
echo "Verify installations with:"
echo "  docker --version"
echo "  docker compose version" 
echo "  node --version"
echo "  go version"
echo "  psql --version"
