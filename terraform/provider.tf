terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.36.0"
    }
    oci = {
      source  = "oracle/oci"
      version = ">= 5.33.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 1.7.4"
}

provider "hcloud" {
  token = var.hetzner_token
}

provider "digitalocean" {
  token = var.digitalocean_token
}

provider "oci" {}