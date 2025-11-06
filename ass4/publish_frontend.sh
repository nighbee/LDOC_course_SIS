#!/bin/bash

set -e

DOCKER_USER="ztktsn"
IMAGE_NAME="esg-frontend"
TAG="latest"
cd /home/almaz/ESG

echo "=== Building ESG Frontend Image ==="
docker build -t $DOCKER_USER/$IMAGE_NAME:$TAG ./frontend

echo "=== Logging in to Docker Hub ==="
docker login

echo "=== Pushing Image to Docker Hub ==="
docker push $DOCKER_USER/$IMAGE_NAME:$TAG

echo "Published successfully:"
echo "docker.io/$DOCKER_USER/$IMAGE_NAME:$TAG"

