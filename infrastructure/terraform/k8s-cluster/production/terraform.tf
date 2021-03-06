terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.20.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
    }
  }
}

provider "linode" {
  token = var.linode_token
}

# https://registry.terraform.io/providers/linode/linode/latest/docs/resources/lke_cluster
resource "linode_lke_cluster" "prod_cluster" {
  label       = var.cluster_name
  k8s_version = var.k8s_version
  region      = var.region
  tags        = ["PROD"]

  pool {
    type  = var.server_type_node
    count = var.nodes
  }
}

resource "local_file" "kubeconfig" {
  depends_on = [linode_lke_cluster.prod_cluster]
  filename   = "kubeconfig"
  content    = base64decode(linode_lke_cluster.prod_cluster.kubeconfig)
}

# Setup helm connection to cluster 
provider "helm" {
  kubernetes {
    config_path = "./kubeconfig"
  }
}

# Install Cert Manager
resource "helm_release" "cert_manager_release" {
  depends_on       = [local_file.kubeconfig]
  name             = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  chart            = "cert-manager"
  version          = "0.1.29"
  repository       = "https://charts.bitnami.com/bitnami"
  wait             = true
  cleanup_on_fail  = true

  set {
    name  = "installCRDs"
    value = true
  }
}

# Install Ingress Controller
resource "helm_release" "ingress_nginx_release" {
  depends_on      = [local_file.kubeconfig]
  name            = "nginx"
  namespace       = "default"
  chart           = "ingress-nginx"
  version         = "4.0.13"
  repository      = "https://kubernetes.github.io/ingress-nginx"
  wait            = true
  cleanup_on_fail = true
}

# Install application
resource "helm_release" "blog_release" {
  depends_on      = [helm_release.cert_manager_release, helm_release.ingress_nginx_release]
  name            = "blog"
  namespace       = "default"
  chart           = "blog"
  version         = var.blog_chart_version
  repository      = "https://granthynd.github.io/helm-charts"
  wait            = true
  cleanup_on_fail = true
}
