terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.43.0"
    }
  }
}

provider "google" {
  #impersonate_service_account = "var.service_account"

  project = var.project_id
  region  = "us-central1"
  zone    = "us-central1-c"
}

