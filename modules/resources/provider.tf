provider "helm" {
  kubernetes {
    host = var.auth.host

    client_certificate     = var.auth.client_certificate
    client_key             = var.auth.client_key
    cluster_ca_certificate = var.auth.cluster_ca_certificate
  }
}

provider "kubernetes" {
    host = var.auth.host

    client_certificate     = var.auth.client_certificate
    client_key             = var.auth.client_key
    cluster_ca_certificate = var.auth.cluster_ca_certificate
  }