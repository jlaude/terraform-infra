

variable "cloud_deploy_cicd_sa_prefix" {
  type = string
}

variable "cicd_project" {

  type = string

}

variable "cloud_build_sa" {
  type    = string
  default = "105666633064@cloudbuild.gserviceaccount.com"
}

