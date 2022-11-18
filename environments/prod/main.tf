terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.43.0"
    }
  }
}

provider "google" {

  project = var.project_id
  region  = "us-central1"
  zone    = "us-central1-c"
}


