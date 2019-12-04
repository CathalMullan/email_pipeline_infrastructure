/*
Variables Configuration
*/

variable "project" {
  description = "The name of the project."
  default     = "distributed_nlp_emails"
}

variable "region" {
  description = "The region to create instances."
  default     = "us-east1"
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster."
  default     = "kubernetes-cluster"
}
