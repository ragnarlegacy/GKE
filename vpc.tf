resource "google_compute_network" "vpc" {
  name                    = "${data.terraform_remote_state.common_vars.outputs.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "gkesubnet"
  region        = data.terraform_remote_state.common_vars.outputs.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}