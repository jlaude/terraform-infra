output "gke_service_account" {
  description = "Service Account used by GKE"
  value       = module.gke.service_account
}

output "cloud_deploy_sa" {
  description = "SA used by Cloud Deploy"
  value       = google_service_account.cloud_deploy_sa
}
