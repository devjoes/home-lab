resource "proxmox_vm_qemu" "nfs_server" {
  depends_on = [
    null_resource.cloud_init_config_files,
  ]

  name        = "nfs-server"
  desc        = "nfs-server"
  target_node = "pve"
  clone       = "ubuntu-10.04-server"
  agent       = 1
  hastate     = ""

  cores    = 1
  sockets  = 1
  cpu      = "host"
  numa     = false
  memory   = "515"
  scsihw   = "lsi"
  bootdisk = "virtio0"

  network {
    firewall = false
    tag      = 99
    model    = "virtio"
    bridge   = "vmbr0"
  }

  disk {
    type    = "virtio"
    storage = "local-lvm"
    size    = var.disk_size
  }

  serial {
    id   = 0
    type = "socket"
  }

  ssh_user        = "root"
  ssh_private_key = <<EOF
-----BEGIN RSA PRIVATE KEY-----
private ssh key root
-----END RSA PRIVATE KEY-----
EOF

  os_type   = "cloud-init"
  ipconfig0 = "ip=10.99.0.2/16,gw=10.99.0.1"
  cicustom  = "user=local:snippets/nfs_server_user_data_vm.yaml"
}
