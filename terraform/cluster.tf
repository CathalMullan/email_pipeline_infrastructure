/*
Distributed Email Pipeline Kubernetes Cluster
*/

resource "google_container_cluster" "distributed-email-pipeline-cluster" {
  name     = var.distributed_email_pipeline_cluster
  project  = "distributed-email-pipeline"
  location = var.distributed_email_pipeline_zone
  network  = google_compute_network.distributed-email-pipeline-network.self_link

  // Disable monitoring and logging to save costs
  logging_service    = "none"
  monitoring_service = "none"

  // Remove initial pool and apply custom pool
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "distributed-email-pipeline-cluster-nodes" {
  name       = "distributed-email-pipeline-cluster-nodes"
  project    = "distributed-email-pipeline"
  location   = var.distributed_email_pipeline_zone
  cluster    = google_container_cluster.distributed-email-pipeline-cluster.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    service_account = var.distributed_email_pipeline_service_account_email

    oauth_scopes = [
      "storage-ro",
      "logging-write",
      "monitoring"
    ]
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 10
  }
}
