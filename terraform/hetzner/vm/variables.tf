variable "module_enabled" {
  type    = bool
  default = false
}

variable "server_dns_ptr" {
  default = null
}

variable "project_name" {
  default = "testing"
}

variable "server_hostname" {
  default = null
}

variable "server_labels" {
  default = { terraform = "" }
}

variable "server_image" {
  default = "ubuntu-20.04"
}

variable "server_server_type" {
  default = "cx11"
}

variable "server_location" {
  default = "nbg1"
}

variable "server_backups" {
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
