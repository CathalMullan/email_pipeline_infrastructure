/*
Batch Kubernetes Cluster
*/

resource "google_container_cluster" "batch-cluster" {
  name     = var.batch_cluster
  project  = var.batch_project
  location = var.batch_zone
  network  = google_compute_network.batch-network.self_link

  // Disable monitoring and logging to save costs
  logging_service    = "none"
  monitoring_service = "none"

  // Remove initial pool and apply custom pool
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "batch-cluster-nodes" {
  name       = "batch-cluster-nodes"
  project    = var.batch_project
  location   = var.batch_zone
  cluster    = google_container_cluster.batch-cluster.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-2"
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 10
  }
}
