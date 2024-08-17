output "region" {
  value = google_storage_bucket.terraform_state.location
}

output "bucket_name" {
  value = google_storage_bucket.terraform_state.name
}

output "project_id" {
  value = google_storage_bucket.terraform_state.project
}

output "env" {
  value = google_storage_bucket.terraform_state.effective_labels.environment
}

output "owner" {
  value = google_storage_bucket.terraform_state.effective_labels.owner
}