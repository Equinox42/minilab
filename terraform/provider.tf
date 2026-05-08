terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.78.2"
    }
    infisical = {
      source  = "infisical/infisical"
      version = "0.16.21"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.19.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.1.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.8.0"
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

provider "infisical" {
  host = var.infisical_hostname
  auth = {
    universal = {
      client_id     = var.infisical_client_id
      client_secret = var.infisical_client_secret
    }
  }
}

provider local {}
provider "kubectl" { config_path = var.kubeconfig_path } 
provider "kubernetes" { config_path = var.kubeconfig_path } 
provider "helm" {}



provider "argocd" {
  server_addr = var.argocd_server_address
  username    = var.argocd_server_username
  password    = var.argocd_server_password
}