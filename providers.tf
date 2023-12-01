data "google_client_config" "current" {
}

provider "google" {
    project = "sagargke"
    credentials = file("sagargke-3c13167c4f7d.json")
}

terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}

# provider "kubernetes" {
#   config_path    = "~/.kube/config"
# }

provider "kubernetes" {
  host                   = "https://${google_container_cluster.gke_cluster.endpoint}"
  cluster_ca_certificate = base64decode(google_container_cluster.gke_cluster.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
}