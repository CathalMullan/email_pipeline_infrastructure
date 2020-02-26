/*
Distributed Email Pipeline Variables Configuration
*/

variable "distributed_email_pipeline_region" {
  description = "Region to create instances."
  default     = "us-east1"
}

variable "distributed_email_pipeline_zone" {
  description = "Zone to create instances."
  default     = "us-east1-b"
}

variable "distributed_email_pipeline_cluster" {
  description = "Name of the Kubernetes cluster."
  default     = "distributed-email-pipeline-cluster"
}

variable "distributed_email_pipeline_service_account" {
  description = "Path to the Service Account of the Kubernetes cluster."
  default     = "~/.config/gcloud/gcp_service_account.json"
}

variable "distributed_email_pipeline_service_account_email" {
  description = "Email of the Service Account of the Kubernetes cluster."
  default     = "terraform@distributed-email-pipeline.iam.gserviceaccount.com"
}
