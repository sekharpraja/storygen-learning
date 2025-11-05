#!/bin/bash

# Submit the build to Google Cloud Build
gcloud builds submit --config backend/cloudbuild.yaml .
gcloud builds submit --config frontend/cloudbuild.yaml .