module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 4.0"

  project_id   = var.project_id
  network_name = var.vpc
  routing_mode = "GLOBAL"

  subnets = var.subnets

  secondary_ranges = var.secondary_ranges

  routes = var.routes


}
