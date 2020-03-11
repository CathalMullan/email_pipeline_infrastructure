/*
Distributed Email Pipeline Network
*/

// Shared VPC used by all clusters.
resource "google_compute_network" "project-network" {
  provider = google-beta
  project  = var.project_id
  name     = "project-network"

  // Delete GCP created firewalls.
  provisioner "local-exec" {
    when    = destroy
    command = "./provisioners/delete_network_firewalls.sh"
  }

  // Delete GCP created forwarding rules.
  provisioner "local-exec" {
    when    = destroy
    command = "./provisioners/delete_network_forwarding_rules.sh"
  }

  // Delete GCP created target pools.
  provisioner "local-exec" {
    when    = destroy
    command = "./provisioners/delete_network_target_pools.sh"
  }

  // Delete GCP created health checks.
  provisioner "local-exec" {
    when    = destroy
    command = "./provisioners/delete_network_health_checks.sh"
  }
}
