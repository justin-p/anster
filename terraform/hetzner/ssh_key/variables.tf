variable "module_enabled" {
  default = false
}

variable "project_name" {
  default = "testing"
}
variable "root_username" {
  description = "The username of the root account"
  default     = "root"
}

variable "root_ssh_key_path" {
  description = "The path of the ssh key for the root account"
  default     = "~/.ssh/temp_key"
}
