resource "random_pet" "name" {
  count = var.module_enabled ? 1 : 0 # only run if this variable is true

  length = 2
}


resource "random_string" "name" {
  count = var.module_enabled ? 1 : 0 # only run if this variable is true

  length  = 6
  special = false
  upper   = false
}

locals {
  # if module_enabled is true
  # if server_hostname is null (which is the default value), generate a random hostname with random_pet and random_string
  # else set it server_hostname to disabled
  server_hostname = var.module_enabled == true ? (var.server_hostname != null ? var.server_hostname : "${random_pet.name[0].id}-${random_string.name[0].result}") : "disabled" # [0] selector is required due the `count = var.module_enabled` trick.

  # if server_dns_ptr is null (which is the default value), disable the PTR creation
  # else set local.dns_ptr
  module_ptr_enabled = var.server_dns_ptr == null ? false : true
  dns_ptr            = var.server_dns_ptr == null ? 0 : var.server_dns_ptr
}


resource "hcloud_server" "main" {
  count = var.module_enabled ? 1 : 0 # only run if this variable is true

  name        = local.server_hostname
  labels      = var.server_labels
  image       = var.server_image
  server_type = var.server_server_type
  location    = var.server_location
  backups     = var.server_backups
  ssh_keys    = var.server_ssh_keys
}

resource "null_resource" "is_server_ready_check" { # ensure that SSH is ready, accepting connections and that cloud-init has finished.
  count = var.module_enabled ? 1 : 0               # only run if this variable is true

  connection {
    type        = "ssh"
    user        = var.root_username
    host        = hcloud_server.main[0].ipv4_address # [0] selector is required due the `count = var.module_enabled` trick.
    private_key = file("${var.root_ssh_key_path}")
  }

  provisioner "remote-exec" {
    inline = ["echo 'Hello world!'"]
  }

  provisioner "local-exec" {
    command = "while ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR ${var.root_username}@${hcloud_server.main[0].ipv4_address} -i ${var.root_ssh_key_path} 'ps aux | grep cloud-init | grep -v grep > /dev/null'; do echo 'Waiting for cloud-init to complete...'; sleep 10; done"
  }

  provisioner "local-exec" {
    command = "while ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR ${var.root_username}@${hcloud_server.main[0].ipv4_address} -i ${var.root_ssh_key_path} 'ps aux | grep apt-get | grep -v grep > /dev/null'; do echo 'Waiting for apt-get to complete...'; sleep 10; done"
  }
}


resource "hcloud_rdns" "main" {
  count = local.module_ptr_enabled ? 1 : 0 # only run if this variable is true

  server_id  = hcloud_server.main[0].id
  ip_address = hcloud_server.main[0].ipv4_address
  dns_ptr    = local.dns_ptr
}
