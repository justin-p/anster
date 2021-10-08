variable "module_enabled" {
  type    = bool
  default = false
}

variable "project_name" {
  default = "testing"
}

variable "project_description" {
  description = "Description of the new to the DigitalOcean Project"
  default     = "Server deployed with Terraform and Ansible template"
}

variable "digitalocean_droplets" {
  default = ""
}
