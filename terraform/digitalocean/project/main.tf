locals {
  droplet_urn = flatten([for output in var.digitalocean_droplets : [for vm_info in output.vm : vm_info["urn"]]]) # get urns from all vms in `var.digitalocean_droplets` output map
}

resource "digitalocean_project" "main" {
  count = var.module_enabled ? 1 : 0 # only run if this variable is true

  name        = var.project_name
  description = var.project_description
  purpose     = "Other"
  resources   = local.droplet_urn # add all created droplets to our project
}
