variable "project_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc" {
  type = string
}

variable "subnets" {
  type = set(object({
    subnet_name      = string
    subnet_ip        = string
    subnet_region    = string
    subnet_flow_logs = string

  }))
  default = []
}

variable "secondary_ranges" {
  type    = map(list(map(string)))
  default = {}
}

variable "routes" {
  type    = set(map(string))
  default = []
}

variable "gcp_service_list" {
  description = "The list of apis necessary for the project"
  type        = list(string)
  default = [
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com"
  ]
}
