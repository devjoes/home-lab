resource "helm_release" "dashboard" {
  name       = "dashboard"
  repository = "https://kubernetes.github.io/dashboard/"
  chart      = "kubernetes-dashboard"
  set {
    name  = "service.type="
    value = "LoadBalancer"
  }
  # Ummmm. Don't ever do this...
  set {
    name  = "extraArgs"
    value = "--enable-skip-login --disable-settings-authorizer --auto-generate-certificates"
  }
}
