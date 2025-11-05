#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Load environment variables
source ./load-env.sh

# --- Deploy Infrastructure with Terraform ---
echo "Deploying infrastructure with Terraform..."
cd terraform_code

# Replace hardcoded values in main.tf with environment variables
sed -i "s/project_id                    = \"sdlc-468305\"/project_id                    = \"$PROJECT_ID\"/g" main.tf
sed -i "s/location                      = \"us-central1\"/location                      = \"$REGION\"/g" main.tf
sed -i "s/service_name                  = \"genai-frontend\"/service_name                  = \"$FRONTEND_SERVICE_NAME\"/g" main.tf
sed -i "s/service_name                  = \"genai-backend\"/service_name                  = \"$BACKEND_SERVICE_NAME\"/g" main.tf
sed -i "s/name          = \"genai-story-images\"/name          = \"$BUCKET_NAME\"/g" main.tf
sed -i "s/container_image\" = \"us-docker.pkg.dev\/cloudrun\/container\/hello\"/container_image\" = \"$FRONTEND_DOCKER_IMAGE\"/g" main.tf
sed -i "s/container_image\" = \"us-docker.pkg.dev\/cloudrun\/container\/hello\"/container_image\" = \"$BACKEND_DOCKER_IMAGE\"/g" main.tf


terraform init
terraform apply -auto-approve

# --- Deploy Cloud Run Services ---
echo "Deploying Cloud Run services..."

# Backend
gcloud run deploy $BACKEND_SERVICE_NAME \
  --image $BACKEND_DOCKER_IMAGE \
  --region $REGION \
  --platform managed \
  --service-account $IMAGEN_API_SA_EMAIL \
  --allow-unauthenticated \
  --set-env-vars="BUCKET_NAME=$BUCKET_NAME"

# Frontend
gcloud run deploy $FRONTEND_SERVICE_NAME \
  --image $FRONTEND_DOCKER_IMAGE \
  --region $REGION \
  --platform managed \
  --allow-unauthenticated \
  --set-env-vars="NEXT_PUBLIC_WS_URL=$(gcloud run services describe $BACKEND_SERVICE_NAME --platform managed --region $REGION --format 'value(status.url)')"

cd ..

echo "Deployment complete."
