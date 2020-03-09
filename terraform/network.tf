/*
Distributed Email Pipeline Network
*/

// Shared VPC used by all clusters.
resource "google_compute_network" "project-network" {
  provider = google-beta
  project  = var.project_id
  name     = "project-network"

  // Delete GCP created firewalls.
  // TODO: Consider using Terraform to create firewalls.
  provisioner "local-exec" {
    when    = destroy
    command = "./provisioners/delete_network_firewalls.sh"
  }
}
