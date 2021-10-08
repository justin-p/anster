terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.23.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.12.1"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 1.0.8"
  experiments      = [module_variable_optional_attrs]
}

provider "hcloud" {
  token = var.hetzner_token
}

provider "digitalocean" {
  token = var.digitalocean_token
}
