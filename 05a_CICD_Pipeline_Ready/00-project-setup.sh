#!/bin/bash

read -p "Enter your GCP project ID: " PROJECT_ID

echo "PROJECT_ID=$PROJECT_ID" > .env

gcloud config set project $PROJECT_ID
