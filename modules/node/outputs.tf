output "nodes" {
  value = [for n in proxmox_vm_qemu.node : { name = n.name, ip = n.ssh_host }]
}
