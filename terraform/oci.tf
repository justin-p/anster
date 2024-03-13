variable "oci_enabled" {
  default     = false
  description = "Determines if terraform will deploy hosts on OCI"
}

variable "oci_servers" {
  description = "A map contaning server(s) that should be created."
  type = map(object({
    availability_domain   = optional(string, "UZHp:eu-amsterdam-1-AD-1")
    instance_display_name = optional(string)
    shape                 = optional(string, "VM.Standard.E2.1.Micro")
    freeform_tags         = map(string)
    source_id             = optional(string, "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaa6impx5efjblyqswpwlrgedcgh7rtdym3ejv2htnt4d7kk3odn2ta") # Ubuntu 22.04 Minimal
    source_type           = optional(string, "image")
  }))
  default = {
    "host1" = {
      freeform_tags = { terraform = "" }
    }
  }
}

locals {
  # if the oci modules are disabled, set oci_compartment.compartment to a empty value
  # otherwise use the output of `module.oci_compartment`.
  oci_compartment = (
    length(module.oci_compartment.compartment) > 0 ?
    module.oci_compartment.compartment[0].id : ""
  )
}

module "oci_compartment" {
  source         = "./oci/compartment"
  module_enabled = var.oci_enabled
}

module "oci_vm" {
  source         = "./oci/vm"
  module_enabled = var.oci_enabled

  oci_compartment_id = local.oci_compartment
  for_each           = var.oci_servers

  root_ssh_private_key_path = var.root_ssh_private_key_path
  root_ssh_public_key_path  = var.root_ssh_public_key_path

  oci_availability_domain   = each.value.availability_domain
  oci_instance_display_name = each.value.instance_display_name
  oci_shape                 = each.value.shape
  oci_freeform_tags         = each.value.freeform_tags
  oci_source_id             = each.value.source_id
  oci_source_type           = each.value.source_type
}

output "oci_vms" {
  value = module.oci_vm
}
