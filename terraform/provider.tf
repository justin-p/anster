terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.23.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.19.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 1.3.7"
}

provider "hcloud" {
  token = var.hetzner_token
}

provider "digitalocean" {
  token = var.digitalocean_token
}
