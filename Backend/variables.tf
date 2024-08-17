variable "bucket_name" {
  description = "The name of the GCS bucket"
  type        = string
}
variable "region" {
  description = "The region in which to create the cluster"
}

variable "project_id" {
  description = "project id"
}
variable "env" {
  description = "The environment for the GKE cluster"
  default     = "test"
}

variable "owner" {
  description = "The environment for the GKE cluster"
  default     = "ragnarakasourav"
}

