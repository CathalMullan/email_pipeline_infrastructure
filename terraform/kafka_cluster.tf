/*
Kafka Kubernetes Cluster
*/

resource "google_container_cluster" "kafka-cluster" {
  name     = "kafka-cluster"
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

resource "google_container_node_pool" "kafka-cluster-nodes" {
  name       = "kafka-cluster-nodes"
  project    = var.project_id
  location   = var.project_zone
  cluster    = google_container_cluster.kafka-cluster.name
  node_count = 2

  // For Kafka, we need consistent, stable instanes with high memory.
  node_config {
    // TODO: Switch to 'false' - Kafka must run continously.
    preemptible     = true
    machine_type    = "n1-standard-2"
    service_account = var.project_service_account_email

    // Use containerd.
    // https://cloud.google.com/kubernetes-engine/docs/concepts/node-images#containerd_node_images
    image_type = "COS"

    // Kafka will have the greatest scopes access, as it was effectively act as the entrypoint to the cluster resources.
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

  autoscaling {
    min_node_count = 2
    max_node_count = 8
  }
}