/*
Distributed Email Pipeline Output
*/

output "kafka-cluster-name" {
  value = google_container_cluster.kafka-cluster.name
}

output "crawler-generator-cluster-name" {
  value = google_container_cluster.crawler-generator-cluster.name
}

output "distributed-email-pipeline_zone" {
  value = var.project_zone
}
