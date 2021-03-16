resource "helm_release" "external_dns" {
  count      = var.powerdns_server == "" ? 0 : 1
  name       = "externaldns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  namespace  = "kube-system"
  set {
    name  = "provider"
    value = "pdns"
  }
  set {
    name  = "pdns.apiUrl"
    value = "http://${var.powerdns_server}"
  }
  set {
    name  = "pdns.apiKey"
    value = var.powerdns_api_key
  }

  set {
    name  = "fqdnTemplates"
    value = "\\{\\{.Name\\}\\}.${var.cluster_fqdn}"
  }
}
