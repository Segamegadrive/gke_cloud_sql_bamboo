/*

This terraform code helps to deploy VPC, GKE cluster
and Bamboo on the cluster. Additionally, it also deploys
Cloud SQL Postgres instance and connects with Private 
Service Access internal IP address.


Confluence doc: https://confluence.endava.com/display/Cloud/Bamboo+on+GKE+and+Cloud+SQL+Postgres+DB+-+Terraform

*/

// Creates a VPC
resource "google_compute_network" "vpc_network" {
    name = var.vpc_name
    auto_create_subnetworks = var.vpc_auto_create_subnets
    mtu = var.vpc_mtu
}

// Creates a VPC subnetwork
resource "google_compute_subnetwork" "vpc_network_subnet" {
  name = var.vpc_subnet_name
  ip_cidr_range = var.vpc_subnet_cidr_range
  region = var.vpc_subnet_region
  network = google_compute_network.vpc_network.id
}

// Add ICMP firewall rule
resource "google_compute_firewall" "vpc_firewall_icmp" {
  name = var.vpc_firewall_icmp_name
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = var.vpc_firewall_icmp_protocol
  }

  source_ranges = var.vpc_firewall_icmp_source_range
}

// Adds a custom firewall rule
resource "google_compute_firewall" "vpc_firewall_custom" {
  name = var.vpc_firewall_custom_name
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = var.vpc_firewall_custom_protocol
  }

  source_ranges = var.vpc_firewall_custom_source_range
}

// Adds a ssh firewall rule
resource "google_compute_firewall" "vpc_firewall_ssh" {
  name = var.vpc_firewall_ssh_name
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = var.vpc_firewall_ssh_protocol
    ports = var.vpc_firewall_ssh_ports
  }

  source_ranges = var.vpc_firewall_ssh_source_range
}

// Adds a rdp firewall rule
resource "google_compute_firewall" "vpc_firewall_rdp" {
  name = var.vpc_firewall_rdp_name
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = var.vpc_firewall_rdp_protocol
    ports = var.vpc_firewall_rdp_port
  }

  source_ranges = var.vpc_firewall_rdp_source_range
}

// Creates a GKE cluster
resource "google_container_cluster" "gke_cluster" {
  name               = var.gke_cluster_name
  location           = var.gke_cluster_location
  initial_node_count = var.gke_cluster_node_count
  network            = google_compute_network.vpc_network.id
  subnetwork         = google_compute_subnetwork.vpc_network_subnet.id
  deletion_protection = var.gke_cluster_del_protection
}

// Deploys Bamboo on the cluster
resource "kubernetes_deployment" "deployment_bamboo" {
  metadata {
    name = "bamboo"
    labels = {
      app = "bamboo"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "bamboo"
      }
    }
    template {
      metadata {
        labels = {
          app = "bamboo"
        }
      }
      spec {
        container {
          name = "bamboo"
          image = "atlassian/bamboo-server:latest"
          port {
            container_port = 8085
          }
        }
      }
    }
  }
}

// Deploys service for bamboo
resource "kubernetes_service" "service_bamboo" {
  metadata {
    name = "bamboo"
  }
  spec {
    selector = {
      app = "bamboo"
    }
    port {
      port = 80
      target_port = 8085
    }
    type = "LoadBalancer"
  }
}

// Allocates internal IP range for Private Service Access
resource "google_compute_global_address" "private_ip_address" {
  provider = google

  name          = var.global_addr_private_ip_name
  purpose       = var.global_addr_purpose
  address_type  = var.global_addr_type
  prefix_length = var.global_addr_prefix_len
  network       = google_compute_network.vpc_network.id
}

// Enables Service Networking API and establish peering
resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google

  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

//Creates Cloud SQL Postgres instance
resource "google_sql_database_instance" "instance" {
  name             = var.sql_instance_name
  region           = var.sql_instance_region
  database_version = var.database_version

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = var.sql_instance_tier
    ip_configuration {
      ipv4_enabled                                  = var.sql_instance_ipv4_enabled
      private_network                               = google_compute_network.vpc_network.id
      enable_private_path_for_google_cloud_services = var.sql_instance_enable_private_path_for_google_cloud_services
    }
  }
  deletion_protection = false
}