
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.0"
    }
  }
#   backend "gcs" {
#     bucket = "remote-backend-state"
#     prefix = "terraform/state"
#   }
}

provider "google" {
  project = var.project_id
  region  = var.region
#   access_token = var.auth_token
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "gke_${var.project_id}_${var.region}_cluster"
}