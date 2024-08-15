data "google_container_engine_versions" "gke_version" {
  location = var.region
  version_prefix = "1.27."
}

resource "google_container_cluster" "primary" {
  name                     = var.cluster_name
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  location   = var.region
  cluster    = google_container_cluster.primary.name

  version = data.google_container_engine_versions.gke_version.release_channel_latest_version["STABLE"]
  node_count = var.node_count
  # Define the node configuration
  node_config {
    # Enable automatic upgrades and repair
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
    ]
    machine_type = var.machine_type
    tags = ["node1"]
    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      env = var.env
    }
  }

    autoscaling {
      min_node_count = var.min_node_count
      max_node_count = var.max_node_count
    }
  }

  # Enable IP Aliasing
#   ip_allocation_policy {
#     use_ip_aliases = true
#     cluster_ipv4_cidr_block = "10.0.0.0/16"
#   }

# Define IAM service account for the nodes
resource "google_service_account" "gke_sa" {
  account_id   = "ragnar-sa"
  display_name = "GKE Service Account"
}

resource "google_project_iam_member" "sa_role" {
  project = var.project_id
  role   = "roles/container.nodeServiceAccount"
  member = "serviceAccount:${google_service_account.gke_sa.email}"
}
