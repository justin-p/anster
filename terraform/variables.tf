variable "project_name" {
  default = "testing"
}

variable "root_username" {
  description = "The username of the root account"
  default     = "root"
}

variable "root_ssh_private_key_path" {
  description = "The path of the ssh key for the root account"
  default     = "~/.ssh/temp_key"
}

variable "root_ssh_public_key_path" {
  description = "The path of the public ssh key for the root account"
  default     = "~/.ssh/temp_key.pub"
}
