resource "helm_release" "nfs" {
  name       = "nfs-subdir-external-provisioner"
  repository = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/"
  chart      = "nfs-subdir-external-provisioner"

  set {
    name  = "nfs.server"
    value = "10.99.0.2"
  }
  set {
    name  = "nfs.path"
    value = "/srv/nfs/k8s"
  }
  set {
    name  = "storageClass.defaultClass"
    value = "true"
  }
}
