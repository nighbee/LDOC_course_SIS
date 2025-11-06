#!/bin/bash 

set -e 

DOCKER_USER="ztktsn"
IMAGE_NAME="esg-backend"
TAG="latest"

echo "=== Building ESG Backend Image ==="
docker build -t $DOCKER_USER/$IMAGE_NAME:$TAG /home/almaz/ESG/backend


echo "Logging in to Docker Hub"
docker login

echo "Pushing Image"
docker push $DOCKER_USER/$IMAGE_NAME:$TAG

echo "Published: docker.io/$DOCKER_USER/$IMAGE_NAME:$TAG"
