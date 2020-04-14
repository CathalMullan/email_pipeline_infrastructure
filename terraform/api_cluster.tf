/*
Api Kubernetes Cluster
*/

resource "google_container_cluster" "api-cluster" {
  name     = "api-cluster"
  project  = var.project_id
  location = var.project_zone
  network  = google_compute_network.project-network.self_link

  // GPU support requires the latest version.
  min_master_version = "latest"

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

resource "google_container_node_pool" "api-cluster-nodes" {
  name       = "api-nodes"
  project    = var.project_id
  location   = var.project_zone
  cluster    = google_container_cluster.api-cluster.name
  node_count = 1

  node_config {
    preemptible     = true
    machine_type    = "n1-standard-1"
    service_account = var.project_service_account_email

    // Use containerd.
    // https://cloud.google.com/kubernetes-engine/docs/concepts/node-images#containerd_node_images
    image_type = "COS"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  // Prevents resizing when applying new changes.
  lifecycle {
    ignore_changes = [initial_node_count]
  }

  // Try to survive.
  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }
}
