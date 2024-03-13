terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.36.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 1.0.8"
}