variable "module_enabled" {
  type    = bool
  default = false
}

variable "server_create_vpc" {
  default = true
}

variable "project_name" {
  default = "testing"
}

variable "server_hostname" {
  default = null
}

variable "server_image" {
  default = "ubuntu-20-04-x64"
}

variable "server_tags" {
  default = ["terraform"]
}

variable "server_size" {
  default = "s-1vcpu-1gb"
}

variable "server_region" {
  default = "ams3"
}

variable "server_backups" {
  default = false
}

variable "server_monitoring" {
  default = false
}

variable "server_ipv6" {
  default = false
}
variable "server_resize_disk" {
  default = true
}

variable "server_droplet_agent" {
  default = false
}

variable "server_ssh_keys" {
  default = ""
}

variable "root_username" {
  description = "The username of the root account"
  default     = "root"
}

variable "root_ssh_key_path" {
  description = "The path of the ssh key for the root account"
  default     = "~/.ssh/temp_key"
}

