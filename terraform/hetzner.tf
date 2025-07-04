variable "hetzner_token" {
  description = "Your Hetzner API token"
  default     = "abcdefghijklmnopqrstuvwqyzabcdefghijklmnopqrstuvwqyzabcdefghijqr"
}

variable "hetzner_enabled" {
  default     = false
  description = "Determines if terraform will deploy hosts on hetzner"
}

variable "hetzner_servers" {
  description = "A map contaning server(s) that should be created."
  type = map(object({
    hostname    = optional(string)
    server_type = optional(string, "cpx11")
    labels      = map(string)
    image       = optional(string, "ubuntu-24.04")
    location    = optional(string, "nbg1")
    backups     = optional(bool, false)
    ptr         = optional(string)
  }))
  default = {
    "host1" = {
      labels = { terraform = "" }
    }
  }
}

locals {
  # if the hetzner modules are disabled, set hetzner_sshkey to a empty value
  # otherwise use the output of `module.hetzner_sshkey`.
  hetzner_ssh_key = (
    length(module.hetzner_ssh_key.ssh_key) > 0 ?
    module.hetzner_ssh_key.ssh_key[0].id : ""
  )
}

module "hetzner_ssh_key" {
  source         = "./hetzner/ssh_key"
  module_enabled = var.hetzner_enabled

  project_name      = var.project_name
  root_username     = var.root_username
  root_ssh_key_path = var.root_ssh_key_path
}

module "hetzner_vm" {
  source         = "./hetzner/vm"
  module_enabled = var.hetzner_enabled
  for_each       = var.hetzner_servers

  root_username     = var.root_username
  root_ssh_key_path = var.root_ssh_key_path

  server_hostname    = each.value.hostname
  server_labels      = each.value.labels
  server_server_type = each.value.server_type
  server_image       = each.value.image
  server_location    = each.value.location
  server_backups     = each.value.backups
  server_ssh_keys    = [local.hetzner_ssh_key]
  server_dns_ptr     = each.value.ptr
}


output "hetzner_vms" {
  value = module.hetzner_vm
}
