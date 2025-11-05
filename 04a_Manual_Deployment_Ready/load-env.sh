#!/bin/bash

# Load environment variables from .env file
# This script is sourced by other deployment scripts to ensure that all necessary
# environment variables are available.

# --- Google Cloud Platform ---
export PROJECT_ID="iconic-mariner-387807"
export REGION="us-central1"
export AR_REPO="storygen"

# --- Backend ---
export BACKEND_SERVICE_NAME="storygen-backend"
export BACKEND_DOCKER_IMAGE="gcr.io/$PROJECT_ID/$AR_REPO/$BACKEND_SERVICE_NAME"

# --- Frontend ---
export FRONTEND_SERVICE_NAME="storygen-frontend"
export FRONTEND_DOCKER_IMAGE="gcr.io/$PROJECT_ID/$AR_REPO/$FRONTEND_SERVICE_NAME"

# --- StoryGen ---
export BUCKET_NAME="storygen-bucket"
export BUCKET_URI="gs://$BUCKET_NAME"

# --- Imagen API ---
export IMAGEN_API_SA="storygen-imagen-sa"
export IMAGEN_API_SA_EMAIL="$IMAGEN_API_SA@$PROJECT_ID.iam.gserviceaccount.com"

# --- From .env.production ---
export NEXT_PUBLIC_WS_URL="wss://genai-backend-clean-453527276826.us-central1.run.app"

echo "Environment variables loaded."
