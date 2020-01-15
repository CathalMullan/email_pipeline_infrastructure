/*
Batch Network
*/

resource "google_compute_network" "batch-network" {
  provider = google-beta
  project  = var.batch_project
  name     = "batch-network"
}
