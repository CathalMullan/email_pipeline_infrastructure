/*
Kubernetes Cluster Creation
*/

resource "google_container_cluster" "gke-cluster" {
  name     = var.cluster_name
  network  = "default"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1
}
