terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.78.2"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.api_token
  insecure  = true
  ssh {
    agent    = true
    username = "root"
  }
}

