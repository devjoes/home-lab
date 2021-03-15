terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.6.7"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = "https://${var.pve_host}:8006/api2/json"
  pm_password     = var.pve_password
  pm_user         = "${var.pve_user}@pam"
  pm_otp          = ""
  # pm_log_enable   = true
  # pm_log_file     = "terraform-plugin-proxmox.log"
  # pm_log_levels = {
  #   _default    = "debug"
  #   _capturelog = ""
  # }
}
