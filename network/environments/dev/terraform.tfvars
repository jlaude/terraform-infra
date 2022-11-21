subnets = [
  {
    subnet_name      = "dev-subnet-us-central1"
    subnet_ip        = "10.2.0.0/16"
    subnet_region    = "us-central1"
    subnet_flow_logs = "true"
  }
]

secondary_ranges = {
  dev-subnet-us-central1 = [
    {
      range_name    = "dev-subnet-secondary-range-pods"
      ip_cidr_range = "10.3.0.0/17"
    },
    {
      range_name    = "dev-subnet-secondary-range-services"
      ip_cidr_range = "10.4.0.0/22"
    }
  ]
}