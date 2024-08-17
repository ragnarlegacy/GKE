terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  backend "gcs" {
    bucket = "remote-backend-state"
    prefix = "terraform/state"
  }
}

data "terraform_remote_state" "common_vars" {
  backend = "local"

  config = {
    path = "Backend/terraform.tfstate"
  }
}
provider "google" {
  project = data.terraform_remote_state.common_vars.outputs.project_id
  region  = data.terraform_remote_state.common_vars.outputs.region
#   access_token = var.auth_token
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "gke_${data.terraform_remote_state.common_vars.outputs.project_id}_${data.terraform_remote_state.common_vars.outputs.region}_cluster"
}
