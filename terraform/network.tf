/*
Distributed Email Pipeline Network
*/

resource "google_compute_network" "distributed-email-pipeline-network" {
  provider = google-beta
  project  = "distributed-email-pipeline"
  name     = "distributed-email-pipeline-network"
}
