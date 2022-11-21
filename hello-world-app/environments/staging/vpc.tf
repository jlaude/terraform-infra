
module "vpc" {

  source = "../../modules/vpc"

  vpc              = var.vpc
  routes           = []
  project_id       = var.project_id
  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges

  depends_on = [google_project_service.gcp_services]
}
