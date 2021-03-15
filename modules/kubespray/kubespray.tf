resource "local_file" "inventory" {
  filename = "${path.root}/.terraform/tmp/inventory.json"
  content  = jsonencode(local.inventory)
}
resource "null_resource" "kubespray" {
  triggers = {
    inventory = local_file.inventory.content
  }
  provisioner "local-exec" {
    #TODO: There is probably a much better way of gaffa taping ansible to terraform
    on_failure = fail
    command    = <<-EOT
              sleep 1m
              set -e
              inventory_path="$(realpath ${path.root}/.terraform/tmp/inventory.json)"
              cd ${path.module}/kubespray
              ansible-playbook -i "$inventory_path" cluster.yml -b -v \
               --private-key=$HOME/.ssh/id_rsa \
               --extra-vars "{helm_enabled: True, metrics_server_enabled: True}"
              EOT
  }
}

resource "null_resource" "get_config" {
  depends_on = [
    null_resource.kubespray
  ]
  triggers = {
    inventory = local_file.inventory.content
  }
  provisioner "local-exec" {
    on_failure = fail
    command    = <<-EOT
          rm ${path.root}/.terraform/tmp/config
          set -e
          ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${var.masters[0].ip} "sudo cp /root/.kube ~/ -av; sudo chown "\$USER:\$USER" ~/.kube -R"
          scp -v -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${var.masters[0].ip}:.kube/config ${path.root}/.terraform/tmp/config
          test -f ${path.root}/.terraform/tmp/config
          EOT
  }
}

data "local_file" "config" {
  depends_on = [
    null_resource.get_config
  ]
  filename = "${path.root}/.terraform/tmp/config"
}