#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Load environment variables
source ./load-env.sh

# --- Configure Docker for Google Cloud ---
echo "Configuring Docker for Google Cloud..."
gcloud auth configure-docker

# --- Build and Push Backend Docker Image ---
echo "Building and pushing backend Docker image..."
docker build -t $BACKEND_DOCKER_IMAGE ./backend
docker push $BACKEND_DOCKER_IMAGE

# --- Build and Push Frontend Docker Image ---
echo "Building and pushing frontend Docker image..."
docker build -t $FRONTEND_DOCKER_IMAGE ./frontend
docker push $FRONTEND_DOCKER_IMAGE

echo "Docker images built and pushed successfully."
