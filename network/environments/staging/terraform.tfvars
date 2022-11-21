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
