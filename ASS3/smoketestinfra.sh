#!/bin/bash
echo "infra smoke test: " 

docker --version &&  echo "Docker: Pass" || echo "Docker: Fail" 
docker compose version && echo "compose: pass" || echo "compose: fail" 
psql --version && echo "postgresql: up" || echo "postgres: fail" 
go version && echo "go: pass" || echo "go: fail" 
node --version && echo "node: pass" || echo "node: fail" 
npm --version && echo "npm: pass" || echo "npm: fail" 
sudo ufw status | head -5 & echo "ufw: pass" || echo "ufw: fail" 
go mod tidy -v && echo "go mod: pass" || echo "go mod: fail" 

