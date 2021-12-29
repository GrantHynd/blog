variable "cluster_name" {
  description = "Cluster name"
  default     = "production-cluster"
}

variable "server_type_master" {
  description = "Master type"
  default     = "g6-standard-1"
}

variable "server_type_node" {
  description = "Node type"
  default     = "g6-standard-1"
}

variable "k8s_version" {
  description = "Version of k8s for the cluster"
  default     = "1.22"
}

variable "region" {
  description = "The region for the cluster"
  default     = "eu-west"
}

variable "nodes" {
  description = "Number of nodes for the cluster"
  default     = 3
}

variable "linode_token" {
  description = " Linode API token"
  default     = "<secret>"
}

variable "root_pass" {
  default = "<secret>"
}

variable "ssh_key" {
  default = "<secret>"
}

variable "blog_chart_version" {
  default = "0.32.0"
}
