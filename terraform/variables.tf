/*
Distributed Email Pipeline Variables Configuration
*/

variable "project_id" {
  description = "Project ID of created GCP project."
  default     = "distributed-email-pipeline"
}

variable "project_region" {
  description = "Region to create instances."
  default     = "us-east1"
}

variable "project_zone" {
  description = "Zone to create instances."
  default     = "us-east1-b"
}

variable "project_service_account" {
  description = "Path to the Service Account of the Kubernetes clusters."
  default     = "~/.config/gcloud/gcp_service_account.json"
}

variable "project_service_account_email" {
  description = "Email of the Service Account of the Kubernetes clusters."
  default     = "terraform@distributed-email-pipeline.iam.gserviceaccount.com"
}
