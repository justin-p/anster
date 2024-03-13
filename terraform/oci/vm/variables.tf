variable "module_enabled" {
  type    = bool
  default = false
}

variable "root_ssh_private_key_path" {
  type    = string
  default = "/home/user/.ssh/id_rsa"
}

variable "root_ssh_public_key_path" {
  type    = string
  default = "/home/user/.ssh/id_rsa.pub"
}

variable "oci_availability_domain" {
  type    = string
  default = "UZHp:eu-amsterdam-1-AD-1"
}

variable "oci_compartment_id" {
  type = string
}

variable "oci_instance_display_name" {
  type    = string
  default = "anster_host"
}

variable "oci_shape" {
  type    = string
  default = "VM.Standard.E2.1.Micro"
}

variable "oci_source_id" {
  type    = string
  default = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaa6impx5efjblyqswpwlrgedcgh7rtdym3ejv2htnt4d7kk3odn2ta"
}

variable "oci_source_type" {
  type    = string
  default = "image"
}

variable "oci_freeform_tags" {
  type = map(string)
}

variable "root_username" {
  type    = string
  default = "ubuntu"
}