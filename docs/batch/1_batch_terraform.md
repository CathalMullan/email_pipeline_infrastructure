# 1 - (Batch) Terraform Setup
Use Terraform to create the batch processing Kubernetes cluster.

# Pre-Requisites
* A Google Cloud Account
* Google Cloud CLI (gcloud)
* Cloud Storage CLI (gsutil)
* Terraform

# Create Project
Login to GCP

```
gcloud auth application-default login
```

Create a project with the name "distributed-nlp-emails-batch" without an organization.

```
gcloud projects create distributed-nlp-emails-batch --name="Batch Distributed NLP Emails"
```

Get the Project ID

```
gcloud projects list
```

```
PROJECT_ID          NAME                            PROJECT_NUMBER
[...]               Batch Distributed NLP Emails    REDACTED
```

Export the following environment variable

```
export PROJECT_ID="[...]"
```

Set the current project using the Project ID.

```
gcloud config set project "${PROJECT_ID}"
```

## Setup Billing
Visit the following site and connect a billing account to the project.

* https://console.cloud.google.com/billing/linkedaccount

## Enable APIs
```
gcloud services enable container.googleapis.com
```

## Create Service Account
Create a service account named "terraform"

```
gcloud beta iam service-accounts create terraform \
    --description "Automated Deployment" \
    --display-name "terraform"
```

Add the following role

```
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role roles/owner
```

Create a JSON key and store it.

```
gcloud iam service-accounts keys create \
    ~/.config/gcloud/batch_terraform.json \
    --iam-account "terraform@${PROJECT_ID}.iam.gserviceaccount.com"
```

## Create Backend Storage
Create a new bucket to store the Terraform state.

```
gsutil mb gs://${PROJECT_ID}-tfstate
```

The bucket created will need to be manually configured in the file `batch_backend.tf`.

## Verify Terraform
Navigate to the `/terraform/batch/` folder, and run the following.

```
terraform init
terraform plan
```

This will download the required providers, and print out the Terraform execution plan.

## Create Resources
Assuming the above plan looks valid, create the resources. Enter 'yes' when prompted.

```
terraform apply
```

## Connect to Cluster
Add the Terraform cluster config to Kubectl.

```
gcloud container clusters get-credentials $(terraform output batch_cluster) --zone $(terraform output batch_zone)
```

## Bootstrap Cluster
Create the namespace `workspace`, and set it as default.

```
kubectl create namespace workspace
kubectl config set-context --current --namespace workspace
```

## Next Step
TODO
