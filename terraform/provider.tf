/*
Distributed Email Pipeline Provider
*/

provider "google-beta" {
  credentials = file(var.distributed_email_pipeline_service_account)
  project     = "distributed-email-pipeline"
  region      = var.distributed_email_pipeline_region
}
