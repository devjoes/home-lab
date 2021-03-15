data "template_file" "node_user_data" {
  count    = var.node_count
  template = file("${path.module}/cloudinit.yaml")
  vars = {
    pubkey    = file("~/.ssh/id_rsa.pub")
    node_type = var.node_type
    hostname  = "${var.node_type}-${count.index}"
    fqdn      = "${var.node_type}-${count.index}.${var.cluster_fqdn}"
  }
}
resource "local_file" "cloud_init_node_user_data_file" {
  count    = var.node_count
  content  = data.template_file.node_user_data[count.index].rendered
  filename = "${path.root}/.terraform/tmp/node_user_data_vm-${var.node_type}-${count.index}.yaml"
}

resource "null_resource" "cloud_init_config_files" {
  count = var.node_count
  connection {
    type     = "ssh"
    user     = var.pve_user
    password = var.pve_password
    host     = var.pve_host
  }

  provisioner "file" {
    source      = local_file.cloud_init_node_user_data_file[count.index].filename
    destination = "/var/lib/vz/snippets/node_user_data_vm-${var.node_type}-${count.index}.yaml"
  }
}
