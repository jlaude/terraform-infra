data "terraform_remote_state" "main" {
  backend = "gcs"


  config ={
    bucket = "0efe1a640c36e423-bucket-tfstate"
    prefix = "terraform/state/project/staging"

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
