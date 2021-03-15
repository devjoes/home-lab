variable "cluster_fqdn" {

}

variable "masters" {

}

variable "workers" {

}

locals {
  master_names     = [for n in var.masters : n.name]
  worker_names     = [for n in var.workers : n.name]
  master_names_map = { for n in var.masters : n.name => null }
  worker_names_map = { for n in var.workers : n.name => null }
  inventory = {
    all = {
      hosts = zipmap(
        concat(local.master_names, local.worker_names),
        [for n in concat(var.masters, var.workers) : { ansible_host = n.ip }]
      )
      children = {
        etcd = {
          hosts = local.master_names_map
        }
        kube-master = {
          hosts = local.master_names_map
        }
        kube-node = {
          hosts = local.worker_names_map
        }
        k8s-cluster = {
          children = {
            "calico-rr"   = null
            "kube-master" = null
            "kube-node"   = null
          }
        }
      }
    }
  }
}
