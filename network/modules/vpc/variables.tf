variable "vpc" {
  type = string
}

variable "project_id" {
  type = string

}

variable "subnets" {
  type = set(object({
    subnet_name               = string
    subnet_ip                 = string
    subnet_region             = string
    subnet_flow_logs          = string

  }))
  default = []
}

variable "secondary_ranges" {
  type    = map(list(map(string)))
  default = {}
}

variable "routes" {
  type = set(map(string))
}
