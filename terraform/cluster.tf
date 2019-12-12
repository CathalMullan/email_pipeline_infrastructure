/*
Kubernetes Cluster Creation
*/

resource "google_container_cluster" "gke-cluster" {
  name               = var.cluster_name
  network            = "default"
  location           = var.region
  initial_node_count = 1

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.cluster_name} --zone ${var.region} --project ${var.project}"
  }
}
