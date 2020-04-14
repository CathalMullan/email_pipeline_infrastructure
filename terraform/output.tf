/*
Distributed Email Pipeline Output
*/

output "kafka-cluster-name" {
  value = google_container_cluster.kafka-cluster.name
}

output "crawler-generator-cluster-name" {
  value = google_container_cluster.crawler-generator-cluster.name
}

output "streaming-cluster-name" {
  value = google_container_cluster.streaming-cluster.name
}

output "tensorflow-cluster-name" {
  value = google_container_cluster.tensorflow-cluster.name
}

output "api-cluster-name" {
  value = google_container_cluster.api-cluster.name
}

output "distributed-email-pipeline_zone" {
  value = var.project_zone
}
