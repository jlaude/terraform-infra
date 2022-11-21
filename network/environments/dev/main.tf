data "terraform_remote_state" "main" {
  backend = "gcs"


  config ={
    bucket = "0efe1a640c36e423-bucket-tfstate"
    prefix = "terraform/state/project/dev"

  }
}

locals {
  environment = data.terraform_remote_state.main.outputs.environment
  project_id  = data.terraform_remote_state.main.outputs.project_id
}


#Create VPC
module "vpc" {

  source = "../../modules/vpc"

  vpc              = "jlaude-labs-${local.environment}-vpc"
  routes           = []
  project_id       = local.project_id
  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges

}

resource "google_compute_router" "router" {
  project = local.project_id
  name    = "nat-router"
  network = "jlaude-labs-${local.environment}-vpc"
  region  = "us-central1"
}

module "cloud-nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "2.2.1"
  project_id                         = local.project_id
  region                             = "us-central1"
  router                             = google_compute_router.router.name
  name                               = "nat-config"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
