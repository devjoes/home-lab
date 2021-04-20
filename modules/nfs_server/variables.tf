terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.6.7"
    }
  }
}

variable "disk_size" {
}

variable "pve_user" {
}
variable "pve_password" {
  sensitive = true
}
variable "pve_host" {
}

variable "cluster_fqdn" {
}
