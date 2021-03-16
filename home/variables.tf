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
variable "master_count" {
  default = 1
}
variable "worker_count" {
  default = 2
}

variable "powerdns_server" {
  default = "192.168.0.10"
}
variable "powerdns_api_key" {
  default   = ""
  sensitive = true
}
