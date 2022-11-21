terraform {
  backend "gcs" {
    bucket = "0efe1a640c36e423-bucket-tfstate"
    prefix = "terraform/state/hello-world-app/dev"
  }
}
