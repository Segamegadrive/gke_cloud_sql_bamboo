variable "vpc_name" {
  type = string
}

variable "vpc_auto_create_subnets" {
  type = bool
  default = false
}

variable "vpc_mtu" {
  type = number
  default = 1460
}

variable "vpc_subnet_name" {
  type = string
  default = "bamboo-vpc-subnet"
}

variable "vpc_subnet_cidr_range" {
  type = string
  default = "10.0.0.0/24"
}

variable "vpc_subnet_region" {
  type = string
  default = "europe-west2"
}

variable "vpc_firewall_icmp_name" {
  type = string
  default = "bamboo-vpc-allow-icmp"
}

variable "vpc_firewall_icmp_protocol" {
  type = string
  default = "icmp"
}

variable "vpc_firewall_icmp_source_range" {
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "vpc_firewall_custom_name" {
  type = string
  default = "bamboo-vpc-allow-custom"
}

variable "vpc_firewall_custom_protocol" {
  type = string
  default = "all"
}

variable "vpc_firewall_custom_source_range" {
  type = list(string)
  default = ["10.0.0.0/24"]
}

variable "vpc_firewall_ssh_name" {
  type = string
  default = "bamboo-vpc-allow-ssh"
}

variable "vpc_firewall_ssh_protocol" {
  type = string
  default = "tcp"
}

variable "vpc_firewall_ssh_ports" {
  type = list(string)
  default = ["22"]
}

variable "vpc_firewall_ssh_source_range" {
  type = list(string)
  default = ["0.0.0.0/0"]
}


variable "vpc_firewall_rdp_name" {
  type = string
  default = "bamboo-vpc-allow-rdp"
}

variable "vpc_firewall_rdp_protocol" {
  type = string
  default = "tcp"
}

variable "vpc_firewall_rdp_port" {
  type = list(string)
  default = [ "3389" ]
}

variable "vpc_firewall_rdp_source_range" {
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "gke_cluster_name" {
  type = string
}

variable "gke_cluster_location" {
  type = string
  default = "europe-west2-a"
}

variable "gke_cluster_node_count" {
  type = number
  default = 3
}

variable "gke_cluster_del_protection" {
  type = bool
  default = false
}


variable "global_addr_private_ip_name" {
  type = string
}

variable "global_addr_purpose" {
  type = string
  default = "VPC_PEERING"
}

variable "global_addr_type" {
  type = string
  default = "INTERNAL"
}

variable "global_addr_prefix_len" {
  type = number
  default = 16
}

variable "sql_instance_name" {
  type = string  
}

variable "sql_instance_region" {
  type = string
}

variable "database_version" {
  type = string
  default = "POSTGRES_15"
}

variable "sql_instance_tier" {
  type = string
  default = "db-f1-micro"
}

variable "sql_instance_ipv4_enabled" {
  type = bool
  default = false
}

variable "sql_instance_enable_private_path_for_google_cloud_services" {
  type = bool
  default = true
}


