locals {
  kubeconfig = yamldecode(data.local_file.config.content)
}

output "auth" {
  sensitive = true
  value = {
    host                   = length(var.masters) == 0 ? "" : "https://${var.masters[0].ip}:6443"
    client_certificate     = base64decode(local.kubeconfig.users[0].user["client-certificate-data"])
    client_key             = base64decode(local.kubeconfig.users[0].user["client-key-data"])
    cluster_ca_certificate = base64decode(local.kubeconfig.clusters[0].cluster["certificate-authority-data"])
  }
}
