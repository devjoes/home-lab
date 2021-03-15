variable "pve_user" {
  default = "root"
}
variable "pve_password" {
  sensitive = true
}
variable "pve_host" {
  default = "192.168.0.200"
}

variable "cluster_fqdn" {
  default = "k8s.pve.home"
}
