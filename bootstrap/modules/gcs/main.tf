resource "google_storage_bucket" "default" {
  name          = var.name
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}
