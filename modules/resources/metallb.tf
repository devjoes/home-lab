resource "kubernetes_config_map" "metallb" {
  metadata {
    name      = "config"
    namespace = "kube-system"
  }
  data = {
    config = <<-EOT
            address-pools:
            - name: default
              protocol: layer2
              addresses:
              - 10.99.0.100-10.99.0.200
             EOT
  }
}

resource "helm_release" "metallb" {
  name       = "metal-lb"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metallb"
  namespace  = "kube-system"
  set {
    name  = "existingConfigMap"
    value = kubernetes_config_map.metallb.metadata[0].name
  }
}
