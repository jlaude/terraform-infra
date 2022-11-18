

resource "google_service_account" "cloud_deploy_sa" {
  account_id   = var.cloud_deploy_cicd_sa_prefix
  display_name = "Cloud Deploy ${var.environment} environment Service Account"
  project      = var.cicd_project
}


resource "google_project_iam_binding" "project" {
  project = var.cicd_project
  role    = "roles/clouddeploy.jobRunner"

  members = [
    "serviceAccount:${var.cloud_deploy_cicd_sa_prefix}@${var.cicd_project}.iam.gserviceaccount.com",
  ]

  depends_on = [google_service_account.cloud_deploy_sa]
}

resource "google_project_iam_binding" "cloud_deploy_sa_gke_viewer" {
  project = var.project_id
  role    = "roles/container.clusterViewer"

  members = [
    "serviceAccount:${var.cloud_deploy_cicd_sa_prefix}@${var.cicd_project}.iam.gserviceaccount.com",
  ]

  depends_on = [google_service_account.cloud_deploy_sa]
}

resource "google_project_iam_binding" "cloud_deploy_sa_gke_developer" {
  project = var.project_id
  role    = "roles/container.developer"

  members = [
    "serviceAccount:${var.cloud_deploy_cicd_sa_prefix}@${var.cicd_project}.iam.gserviceaccount.com",
  ]

  depends_on = [google_service_account.cloud_deploy_sa]
}

