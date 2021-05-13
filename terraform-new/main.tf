provider "google" {
  credentials = file("../gke-service-account.json")
  project     = var.project_id
  region      = var.region
}

# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

provider "kubernetes" {
  load_config_file       = false
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke_auth" {
  source       = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  depends_on   = [module.gke]
  project_id   = var.project_id
  location     = module.gke.location
  cluster_name = module.gke.name
}

resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "kubeconfig-${var.env_name}"
}

module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  project_id   = var.project_id
  network_name = "${var.network}-${var.env_name}"
  subnets = [
    {
      subnet_name   = "${var.subnetwork}-${var.env_name}"
      subnet_ip     = "10.10.0.0/16"
      subnet_region = var.region
    },
  ]
  secondary_ranges = {
    "${var.subnetwork}-${var.env_name}" = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = "10.20.0.0/16"
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = "10.30.0.0/16"
      },
    ]
  }
}

module "gke" {
  source                      = "terraform-google-modules/kubernetes-engine/google"
  project_id                  = var.project_id
  name                        = "${var.cluster_name}-${var.env_name}"
  regional                    = true
  region                      = var.region
  network                     = module.gcp-network.network_name
  subnetwork                  = module.gcp-network.subnets_names[0]
  create_service_account      = false
  service_account             = var.compute_engine_service_account
  enable_binary_authorization = var.enable_binary_authorization
  ip_range_pods               = var.ip_range_pods_name
  ip_range_services           = var.ip_range_services_name
  remove_default_node_pool    = true
  node_pools = [
    {
      name            = "node-pool"
      machine_type    = "e2-medium"
      node_locations  = "europe-west2-a,europe-west2-b,europe-west2-c"
      min_count       = 1
      max_count       = 3
      disk_size_gb    = 30
      service_account = var.compute_engine_service_account
    },
  ]
}
