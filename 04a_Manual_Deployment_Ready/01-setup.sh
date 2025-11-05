#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Load environment variables
source ./load-env.sh

# --- Authenticate and Configure Google Cloud ---
echo "Authenticating to Google Cloud..."
gcloud auth login
gcloud config set project $PROJECT_ID

# --- Enable Required Google Cloud Services ---
echo "Enabling required Google Cloud services..."
gcloud services enable \
  run.googleapis.com \
  iam.googleapis.com \
  containerregistry.googleapis.com \
  storage-component.googleapis.com \
  iamcredentials.googleapis.com \
  cloudresourcemanager.googleapis.com

# --- Create Google Cloud Storage Bucket ---
echo "Creating Google Cloud Storage bucket..."
gsutil mb -p $PROJECT_ID -l $REGION $BUCKET_URI

# --- Create IAM Service Account for Imagen API ---
echo "Creating IAM service account for Imagen API..."
gcloud iam service-accounts create $IMAGEN_API_SA \
    --description="Service account for StoryGen to access Imagen API" \
    --display-name="StoryGen Imagen SA"

# --- Grant IAM Roles to Service Account ---
echo "Granting IAM roles to the service account..."
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$IMAGEN_API_SA_EMAIL" \
    --role="roles/aiplatform.user"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$IMAGEN_API_SA_EMAIL" \
    --role="roles/storage.objectAdmin"

echo "Setup complete."
