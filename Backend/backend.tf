resource "google_service_account" "bucket_remote_sa" {
  account_id   = "remote-backend"
  project = var.project_id
  display_name = "Remote Backend Service Account"
}

resource "google_project_iam_member" "bucket_sa_role" {
  project = var.project_id
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.bucket_remote_sa.email}"
}

resource "google_storage_bucket" "terraform_state" {
  name     = var.bucket_name
  project =  var.project_id
  location = var.region
  force_destroy = true

  versioning {
    enabled = true
  }
  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }

  labels = {
    environment = var.env
    owner = var.owner
  }
}