# https://dev.to/farisdurrani/using-terraform-to-deploy-an-oci-compute-instance-597f
# facilitate automagic creation of compartments so we don't have to set the main compartment id.
# using some magic file parsing that gets the contents of the ~/.oci/config file so we don't
# manually have to set the tenancy_id as the root compartment_id

locals {
  raw_lines = [
    for line in split("\n", file("~/.oci/config")) :
    split("=", trimspace(line))
  ]
  lines = [
    for line in local.raw_lines :
    line if length(line[0]) > 0 && substr(line[0], 0, 1) != "#" && strcontains(line[0], "[") == false
  ]
  records = { for line in local.lines : line[0] => line[1] }
}

resource "oci_identity_compartment" "anster_compartment" {
  count = var.module_enabled ? 1 : 0 # only run if this variable is true

  compartment_id = local.records.tenancy
  description    = var.oci_compartment_description
  name           = var.oci_compartment_name
}