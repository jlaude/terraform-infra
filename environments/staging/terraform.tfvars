project_id  = "jlaude-labs-staging"
environment = "staging"

service_account = ""

vpc = "jlaude-labs-vpc"

subnets = [
  {
    subnet_name   = "subnet-01"
    subnet_ip     = "10.10.10.0/24"
    subnet_region = "us-west1"
  },
  {
    subnet_name           = "subnet-02"
    subnet_ip             = "10.10.20.0/24"
    subnet_region         = "us-west1"
    subnet_private_access = "true"
    subnet_flow_logs      = "true"
    description           = "This subnet has a description"
  },
  {
    subnet_name               = "subnet-03"
    subnet_ip                 = "10.10.30.0/24"
    subnet_region             = "us-west1"
    subnet_flow_logs          = "true"
    subnet_flow_logs_interval = "INTERVAL_10_MIN"
    subnet_flow_logs_sampling = 0.7
    subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
  }
]

secondary_ranges = {
  subnet-01 = [
    {
      range_name    = "subnet-01-secondary-01"
      ip_cidr_range = "192.168.64.0/24"
    },
  ]

  subnet-02 = []
}

