resource "helm_release" "dashboard" {
  name       = "dashboard"
  repository = "https://kubernetes.github.io/dashboard/"
  chart      = "kubernetes-dashboard"

  # Ummmm. Don't ever do this...
  values = [
    <<-EOT
		fullnameOverride: dashboard
		service: {type: LoadBalancer}
		extraArgs:
		- --enable-skip-login
		- --disable-settings-authorizer
		- --auto-generate-certificates
	EOT
  ]
}

# Really dont ever do this.
resource "kubernetes_cluster_role_binding" "bad_practice" {
  metadata {
    name = "dashboard_admin_fail"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    api_group = ""
    kind      = "ServiceAccount"
    namespace = "default"
    name      = "dashboard"
  }
}
