resource "random_pet" "main" {}

resource "random_string" "main" {
  length  = 5
  special = false
}

resource "oci_core_vcn" "main" {
  count = var.module_enabled ? 1 : 0 # only run if this variable is true

  cidr_block     = "10.0.0.0/16"
  compartment_id = var.oci_compartment_id
  display_name   = "vcn_anster_${random_pet.main.id}"
  dns_label      = "anster${random_string.main.id}"
}

resource "oci_core_subnet" "main" {
  count = var.module_enabled ? 1 : 0 # only run if this variable is true

  cidr_block     = "10.0.0.0/24"
  compartment_id = var.oci_compartment_id
  display_name   = "subnet_anster_${random_pet.main.id}"
  dns_label      = "anster${random_string.main.id}"
  route_table_id = oci_core_vcn.main[0].default_route_table_id
  vcn_id         = oci_core_vcn.main[0].id
}

resource "oci_core_internet_gateway" "main" {
  count = var.module_enabled ? 1 : 0 # only run if this variable is true

  compartment_id = var.oci_compartment_id
  display_name   = "Internet Gateway anster ${random_pet.main.id}"
  enabled        = "true"
  vcn_id         = oci_core_vcn.main[0].id
}

resource "oci_core_default_route_table" "main" {
  count = var.module_enabled ? 1 : 0 # only run if this variable is true

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.main[0].id
  }
  manage_default_resource_id = oci_core_vcn.main[0].default_route_table_id
}

resource "oci_core_instance" "main" {
  count = var.module_enabled ? 1 : 0 # only run if this variable is true
  agent_config {
    is_management_disabled = "false"
    is_monitoring_disabled = "false"
    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Management Agent"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Custom Logs Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute RDMA GPU Monitoring"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute HPC RDMA Auto-Configuration"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute HPC RDMA Authentication"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Block Volume Management"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }
  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }
  availability_domain = var.oci_availability_domain
  compartment_id      = var.oci_compartment_id
  create_vnic_details {
    assign_ipv6ip             = "false"
    assign_private_dns_record = "false"
    assign_public_ip          = "true"
    subnet_id                 = oci_core_subnet.main[0].id
  }
  display_name = "${var.oci_instance_display_name}_${random_pet.main.id}"
  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }
  metadata = {
    ssh_authorized_keys = file(var.root_ssh_public_key_path)
  }
  shape = var.oci_shape
  source_details {
    source_id   = var.oci_source_id
    source_type = "image"
  }
  freeform_tags = var.oci_freeform_tags
}

resource "null_resource" "is_server_ready_check" { # ensure that SSH is ready, accepting connections, that cloud-init and apt-get has finished.
  count = var.module_enabled ? 1 : 0               # only run if this variable is true

  connection {
    type        = "ssh"
    user        = var.root_username
    host        = oci_core_instance.main[0].public_ip # [0] selector is required due the `count = var.module_enabled` trick.
    private_key = file("${var.root_ssh_private_key_path}")
  }

  provisioner "remote-exec" {
    inline = ["echo 'Hello world!'"]
  }

  provisioner "local-exec" {
    command = "while ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR ${var.root_username}@${oci_core_instance.main[0].public_ip} -i ${var.root_ssh_private_key_path} 'ps aux | grep cloud-init | grep -v grep > /dev/null'; do echo 'Waiting for cloud-init to complete...'; sleep 10; done"
  }

  provisioner "local-exec" {
    command = "while ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR ${var.root_username}@${oci_core_instance.main[0].public_ip} -i ${var.root_ssh_private_key_path} 'ps aux | grep apt-get | grep -v grep > /dev/null'; do echo 'Waiting for apt-get to complete...'; sleep 10; done"
  }
}
