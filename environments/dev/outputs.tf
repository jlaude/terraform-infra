
output "cloud_deloy_sa" {
  description = "Service Account used by Cloud Deploy"
  value       = google_service_account.cloud_deploy_sa.email
}

