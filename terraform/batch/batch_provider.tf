/*
Batch Provider
*/

provider "google-beta" {
  credentials = file("~/.config/gcloud/batch_terraform.json")
  project     = var.batch_project
  region      = var.batch_region
}
