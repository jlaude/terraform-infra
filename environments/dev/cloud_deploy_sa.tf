#Create cloud deploy SA
resource "google_service_account" "cloud_deploy_sa" {
  account_id   = var.cloud_deploy_cicd_sa_prefix
  display_name = "Cloud Deploy ${var.environment} environment Service Account"
  project      = var.cicd_project
}

# Granting Cloud Build Service Account User permissions on Cloud Deploy SA
module "iam_service_accounts_iam" {
  source  = "terraform-google-modules/iam/google//modules/service_accounts_iam"
  version = "7.4.1"

  service_accounts = [google_service_account.cloud_deploy_sa.email]
  project          = var.cicd_project
  mode             = "additive"
  bindings = {
    "roles/iam.serviceAccountUser" = [
      "serviceAccount:${var.cloud_build_sa}",
    ]
  }

}

#Grant permissions in environment on Cloud Deploy SA
module "project_iam_binding_environment_project" {

  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "7.4.1"
  projects = [var.project_id]
  mode     = "additive"

  bindings = {
    "roles/container.clusterViewer" = [
    "serviceAccount:${var.cloud_deploy_cicd_sa_prefix}@${var.cicd_project}.iam.gserviceaccount.com",
    ]
    "roles/container.developer" = [
    "serviceAccount:${var.cloud_deploy_cicd_sa_prefix}@${var.cicd_project}.iam.gserviceaccount.com",
    ]
  }
  depends_on = [google_service_account.cloud_deploy_sa]
}

#Grant permissions in CICD project on Cloud Deploy SA
module "project_iam_binding_cicd_project" {

  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "7.4.1"
  projects = [var.cicd_project]
  mode     = "additive"

  bindings = {
    "roles/clouddeploy.jobRunner" = [
    "serviceAccount:${var.cloud_deploy_cicd_sa_prefix}@${var.cicd_project}.iam.gserviceaccount.com",
    ]
  }
  depends_on = [google_service_account.cloud_deploy_sa]
}
