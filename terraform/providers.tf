/*
Provider Configuration
*/

provider "google" {
  credentials = file("~/.terraform/config.json")
  project     = var.project
  region      = var.region
}
