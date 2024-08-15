variable "project_id" {
  description = "project id"
}

# variable "auth_token" {
#   description = "auth access token"
# }

variable "region" {
  description = "The region in which to create the cluster"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  default     = "viking-cluster"
}

variable "machine_type" {
  description = "The machine type to use for the cluster"
  default     = "e2-medium"
}

variable "node_count" {
  description = "The number of nodes to create in the default node pool"
  default     = 1
}

variable "min_node_count" {
  description = "The minimum number of nodes for autoscaling"
  default     = 1
}

variable "max_node_count" {
  description = "The maximum number of nodes for autoscaling"
  default     = 3
}

variable "env" {
  description = "The environment for the GKE cluster"
  default     = "test"
}

variable "bucket_name" {
  description = "The name of the GCS bucket"
  type        = string
}