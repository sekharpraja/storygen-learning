# StoryGen CI/CD Pipeline

This document describes how to set up the CI/CD pipeline for the StoryGen application.

## Prerequisites

- A Google Cloud project
- A GitHub repository for the StoryGen application
- `gcloud` CLI installed and authenticated

## Setup Steps

1.  **Set up the Project:**

    Run the following script to set up the project:

    ```bash
    bash 00-project-setup.sh
    ```

2.  **Enable Google Cloud Services:**

    Run the following script to enable the required Google Cloud services:

    ```bash
    bash 01-enable-services.sh
    ```

3.  **Create a Service Account:**

    Run the following script to create a service account and grant it the necessary permissions:

    ```bash
    bash 02-create-service-account.sh
    ```

    This will create a service account and a JSON key file named `github-actions-key.json`. If the file already exists, it will be overwritten.

4.  **Add the Service Account Key to GitHub Secrets:**

    - Go to your GitHub repository's **Settings** > **Secrets and variables** > **Actions**.
    - Click **New repository secret**.
    - Name the secret `GCP_SA_KEY`.
    - Copy the contents of the `github-actions-key.json` file and paste it into the **Value** field.

5.  **Push to GitHub:**

    Push the code to the `main` branch of your GitHub repository. This will trigger the GitHub Actions workflow and deploy the application.

## Manual Build Submission (Optional)

To manually submit builds for both the backend and frontend to Google Cloud Build, run the following script:

```bash
bash 03-submit-build.sh
```
