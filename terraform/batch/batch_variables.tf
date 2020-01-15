/*
BATCH Variables Configuration
*/

variable "batch_project" {
  description = "Name of the project."
  default     = "distributed-nlp-emails-batch"
}

variable "batch_region" {
  description = "Region to create instances."
  default     = "us-east1"
}

variable "batch_zone" {
  description = "Zone to create instances."
  default     = "us-east1-b"
}

variable "batch_cluster" {
  description = "Name of the Kubernetes cluster."
  default     = "batch-cluster"
}
