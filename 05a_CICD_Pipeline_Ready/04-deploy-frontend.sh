#!/bin/bash

PROJECT_ID=$(gcloud config get-value project)
BACKEND_URL=$(gcloud run services describe storygen-backend --platform managed --region us-central1 --format 'value(status.url)')

gcloud run deploy storygen-frontend \
  --image gcr.io/$PROJECT_ID/storygen-frontend \
  --region us-central1 \
  --platform managed \
  --allow-unauthenticated \
  --set-env-vars=NEXT_PUBLIC_BACKEND_URL=$BACKEND_URL

