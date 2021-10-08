resource "hcloud_ssh_key" "main" {
  count = var.module_enabled ? 1 : 0 # only run if this variable is true

  name       = "${var.project_name}-${var.root_username}"
  public_key = file("${var.root_ssh_key_path}.pub")
}
