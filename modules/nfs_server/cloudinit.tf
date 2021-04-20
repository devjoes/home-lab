data "template_file" "nfs_server_user_data" {
  template = file("${path.module}/cloudinit.yaml")
  vars = {
    pubkey   = file("~/.ssh/id_rsa.pub")
    hostname = "nfs_server"
    fqdn     = "nfs_server.${var.cluster_fqdn}"
  }
}
resource "local_file" "cloud_init_nfs_server_user_data_file" {
  content  = data.template_file.nfs_server_user_data.rendered
  filename = "${path.root}/.terraform/tmp/nfs_server_user_data_vm.yaml"
}

resource "null_resource" "cloud_init_config_files" {
  connection {
    type     = "ssh"
    user     = var.pve_user
    password = var.pve_password
    host     = var.pve_host
  }

  provisioner "file" {
    source      = local_file.cloud_init_nfs_server_user_data_file.filename
    destination = "/var/lib/vz/snippets/nfs_server_user_data_vm.yaml"
  }
}
