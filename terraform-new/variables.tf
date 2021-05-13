variable "project_id" {
  description = "The project ID to host the cluster in"
  default     = "steam-kingdom-311415"
}
variable "cluster_name" {
  description = "The name for the GKE cluster"
  default     = "studyjam-cluster"
}
variable "env_name" {
  description = "The environment for the GKE cluster"
  default     = "prod"
}
variable "region" {
  description = "The region to host the cluster in"
  default     = "europe-west2"
}
variable "network" {
  description = "The VPC network created to host the cluster in"
  default     = "gke-network"
}
variable "subnetwork" {
  description = "The subnetwork created to host the cluster in"
  default     = "gke-subnet"
}
variable "ip_range_pods_name" {
  description = "The secondary ip range to use for pods"
  default     = "ip-range-pods"
}
variable "ip_range_services_name" {
  description = "The secondary ip range to use for services"
  default     = "ip-range-services"
}

variable "compute_engine_service_account" {
  description = "The service account"
  default     = "gke-service-account@steam-kingdom-311415.iam.gserviceaccount.com"
}

variable "enable_binary_authorization" {
  description = "Enable BinAuthZ Admission controller"
  default     = false
}