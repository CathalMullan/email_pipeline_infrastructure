/*
Streaming Kubernetes Cluster
*/

resource "google_container_cluster" "streaming-cluster" {
  name     = "streaming-cluster"
  project  = var.project_id
  location = var.project_zone
  network  = google_compute_network.project-network.self_link

  // Disable monitoring and logging to save costs
  logging_service    = "none"
  monitoring_service = "none"

  // Remove initial pool and apply custom pool.
  remove_default_node_pool = true
  initial_node_count       = 1

  depends_on = [
    google_compute_network.project-network
  ]
}

resource "google_container_node_pool" "streaming-cluster-nodes" {
  name       = "streaming-nodes"
  project    = var.project_id
  location   = var.project_zone
  cluster    = google_container_cluster.streaming-cluster.name
  node_count = 1

  // For the Spark Streaming nodes, we can use small, preemptable instances.
  node_config {
    preemptible     = true
    machine_type    = "n1-standard-2"
    service_account = var.project_service_account_email

    // Use containerd.
    // https://cloud.google.com/kubernetes-engine/docs/concepts/node-images#containerd_node_images
    image_type = "COS"

    // TODO: Evaluate required scopes - unlikely to need currently elavated priveldge.
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  // Autoscale as required to manage Kafka queue consumption.
  autoscaling {
    min_node_count = 1
    max_node_count = 8
  }
}
