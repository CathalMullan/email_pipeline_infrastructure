/*
Distributed Email Pipeline Provider
*/

provider "google-beta" {
  version     = "3.9.0"
  credentials = file(var.project_service_account)
  project     = var.project_id
  region      = var.project_region
}
