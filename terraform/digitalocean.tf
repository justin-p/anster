variable "digitalocean_token" {
  description = "Your DigitalOcean API token generated from here https://cloud.digitalocean.com/account/api/tokens"
  default     = "123465789"
}

variable "digitalocean_enabled" {
  default     = false
  description = "Determines if terraform will deploy hosts on digitalocean"
}

variable "digitalocean_servers" {
  #  'create_vpc' will create a VPC for each droplet
  # is set to true by default to avoid a server from using the default regions VPC and the fact that you can't disable the default VPC
  # if you your project requires multiple droplets in the same VPC please update the terraform code manually
  description = "A map contaning server(s) that should be created."
  type = map(object({
    hostname      = optional(string)
    size          = optional(string, "s-1vcpu-1gb")
    tags          = list(string)
    image         = optional(string, "ubuntu-20-04-x64")
    region        = optional(string, "ams3")
    backups       = optional(bool, false)
    monitoring    = optional(bool, false)
    ipv6          = optional(bool, false)
    resize_disk   = optional(bool, true)
    droplet_agent = optional(bool, false)
    create_vpc    = optional(bool, true)
  }))
  default = {
    "host1" = {
      tags = ["terraform"]
    }
  }
}

## default values if incomplete server map is supplied
locals {
  # if the digitalocean modules are disabled, set digitalocean_ssh_key to a empty value
  # otherwise use the output of `module.digitalocean_ssh_key`.
  digitalocean_ssh_key = (
    length(module.digitalocean_ssh_key.ssh_key) > 0 ?
    module.digitalocean_ssh_key.ssh_key[0].fingerprint : ""
  )
}

module "digitalocean_ssh_key" {
  source         = "./digitalocean/ssh_key"
  module_enabled = var.digitalocean_enabled

  root_username     = var.root_username
  root_ssh_key_path = var.root_ssh_key_path
}

module "digitalocean_vm" {
  source         = "./digitalocean/vm"
  module_enabled = var.digitalocean_enabled
  for_each       = var.digitalocean_servers

  root_username     = var.root_username
  root_ssh_key_path = var.root_ssh_key_path

  server_hostname      = each.value.hostname
  server_tags          = each.value.tags
  server_size          = each.value.size
  server_image         = each.value.image
  server_region        = each.value.region
  server_backups       = each.value.backups
  server_monitoring    = each.value.monitoring
  server_ipv6          = each.value.ipv6
  server_resize_disk   = each.value.resize_disk
  server_droplet_agent = each.value.droplet_agent
  server_create_vpc    = each.value.create_vpc
  server_ssh_keys      = [local.digitalocean_ssh_key]
}

module "digitalocean_project" {
  source         = "./digitalocean/project"
  module_enabled = var.digitalocean_enabled

  digitalocean_droplets = module.digitalocean_vm
}

output "digitalocean_vms" {
  value = module.digitalocean_vm
}
