# 1 - Google Cloud Platform Setup

# Pre-Requisites
* A Google Cloud Account
* Google Cloud CLI (gcloud)
* Cloud Storage CLI (gsutil)

## Download CLI Tools
Google Cloud CLI (`gcloud`)

```console
wget -q -O /tmp/gcloud.tgz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-281.0.0-darwin-x86_64.tar.gz
tar xzf /tmp/gcloud.tgz -C /tmp
/tmp/google-cloud-sdk/install.sh
```

Cloud Storage CLI (`gsutil`)

```console
curl https://sdk.cloud.google.com | bash
```

Restart shell

```
exec -l $SHELL
```

Verify install

```
gcloud --version
gsutil --version
```

## Create Project
Login to GCP

```
gcloud auth application-default login
```

Create a project with the name "distributed-email-pipeline" without an organization.

```
gcloud projects create distributed-email-pipeline --name="distributed-email-pipeline"
```

Get the Project ID

```
gcloud projects list
```

```
PROJECT_ID      NAME                            PROJECT_NUMBER
[...]           distributed-email-pipeline      ...
```

Set the current project using the Project ID.

```
gcloud config set project "distributed-email-pipeline"
```

## Setup Billing
Visit the following site and connect a billing account to the project.

* https://console.cloud.google.com/billing/linkedaccount

## Enable APIs
```
gcloud services enable container.googleapis.com
```
