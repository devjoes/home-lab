/* Configure cloud-init User-Data with custom config file */
resource "proxmox_vm_qemu" "node" {
  depends_on = [
    null_resource.cloud_init_config_files,
  ]
  count = var.node_count

  name        = "${var.node_type}-${count.index}"
  desc        = "node"
  target_node = "pve"
  clone       = "ubuntu-10.04-server"
  agent       = 1
  hastate     = ""

  cores    = var.cores
  sockets  = 1
  cpu      = "host"
  numa     = false
  memory   = var.memory
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
  ipconfig0 = "ip=10.99.0.${var.ip_offset + count.index}/16,gw=10.99.0.1"
  cicustom  = "user=local:snippets/node_user_data_vm-${var.node_type}-${count.index}.yaml"
}
