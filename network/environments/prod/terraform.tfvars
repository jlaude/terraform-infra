subnets = [
  {
    subnet_name      = "prod-subnet-us-central1"
    subnet_ip        = "10.50.0.0/16"
    subnet_region    = "us-central1"
    subnet_flow_logs = "true"
  }
]

secondary_ranges = {
  prod-subnet-us-central1 = [
    {
      range_name    = "prod-subnet-secondary-range-pods"
      ip_cidr_range = "10.51.0.0/17"
    },
    {
      range_name    = "prod-subnet-secondary-range-services"
      ip_cidr_range = "10.52.0.0/22"
    }
  ]
}
