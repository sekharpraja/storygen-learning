#!/bin/bash

PROJECT_ID=$(gcloud config get-value project)
SERVICE_ACCOUNT_NAME="github-actions-sa"

# Check if service account already exists
if gcloud iam service-accounts describe $SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com &> /dev/null; then
    echo "Service account $SERVICE_ACCOUNT_NAME already exists."
else
    # Create service account
    gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
        --description="Service account for GitHub Actions" \
        --display-name="GitHub Actions SA"
fi

# Grant roles to service account
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/run.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/iam.serviceAccountUser"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/cloudbuild.builds.editor"

# Create and download service account key
if [ -f github-actions-key.json ]; then
    rm github-actions-key.json
fi
gcloud iam service-accounts keys create github-actions-key.json \
    --iam-account="$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"
