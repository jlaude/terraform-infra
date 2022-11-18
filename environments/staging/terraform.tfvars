project_id  = "jlaude-labs-staging"
environment = "staging"


vpc = "jlaude-labs-staging-vpc"


subnets = [
  {
    subnet_name      = "staging-subnet-us-central1"
    subnet_ip        = "10.10.0.0/16"
    subnet_region    = "us-central1"
    subnet_flow_logs = "true"
  }
]

secondary_ranges = {
  staging-subnet-us-central1 = [
    {
      range_name    = "staging-subnet-secondary-range-pods"
      ip_cidr_range = "10.11.0.0/17"
    },
    {
      range_name    = "staging-subnet-secondary-range-services"
      ip_cidr_range = "10.12.0.0/22"
    }
  ]
}

cloud_deploy_cicd_sa_prefix = "cloud-deploy-staging-sa"

cicd_project = "dev-demo-project-366116"
