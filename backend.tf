resource "google_service_account" "bucket_remote_sa" {
  account_id   = "remote-backend"
  display_name = "Remote Backend Service Account"
}

resource "google_project_iam_member" "bucket_sa_role" {
  project = var.project_id
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.bucket_remote_sa.email}"
}


resource "google_storage_bucket" "terraform_state" {
  name     = var.bucket_name
  location = var.region
  force_destroy = true

  versioning {
    enabled = true
  }
}