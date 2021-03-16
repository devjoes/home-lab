module "masters" {
  source       = "../modules/node"
  node_type    = "master"
  node_count   = var.master_count
  ip_offset    = 10
  cores        = 1
  memory       = 2560
  disk_size    = "50G"
  pve_user     = var.pve_user
  pve_password = var.pve_password
  pve_host     = var.pve_host
  cluster_fqdn = var.cluster_fqdn
}

module "workers" {
  source       = "../modules/node"
  node_type    = "worker"
  node_count   = var.worker_count
  ip_offset    = 20
  cores        = 2
  memory       = 4096
  disk_size    = "100G"
  pve_user     = var.pve_user
  pve_password = var.pve_password
  pve_host     = var.pve_host
  cluster_fqdn = var.cluster_fqdn
}

module "kubespray" {
  depends_on = [
    module.masters,
    module.workers
  ]
  source       = "../modules/kubespray"
  masters      = module.masters.nodes
  workers      = module.workers.nodes
  node_count   = var.master_count + var.worker_count
  cluster_fqdn = var.cluster_fqdn
}

module "resources" {
  source           = "../modules/resources"
  auth             = module.kubespray.auth
  powerdns_server  = var.powerdns_server
  powerdns_api_key = var.powerdns_api_key
  cluster_fqdn     = var.cluster_fqdn
}
