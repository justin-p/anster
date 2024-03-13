output "oci_config" {
  value = local.records
}

output "compartment" {
  value = oci_identity_compartment.anster_compartment
}