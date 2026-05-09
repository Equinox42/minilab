resource "proxmox_virtual_environment_vm" "infisical" {


  name        = "Infisical"
  description = "Infisical - Vault for Secrets"
  tags        = concat(["Infisical"])
  node_name   = var.proxmox_node
  started     = true

  stop_on_destroy = true

  clone {
    vm_id = var.template_id
  }

  cpu {
    cores = var.infisical_cpu
    type  = "host"
    numa  = false
  }

  memory {
    dedicated = var.infisical_memory
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    file_format  = "raw"
    size         = var.infisical_disksize
  }

  agent {
    enabled = false
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${var.infisical_ip_adress}/24"
        gateway = var.gateway
      }
    }
    user_account {
      username = var.username
      keys     = [var.ssh_key]
    }
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  lifecycle {
    prevent_destroy = true
  }
}

data "http" "infisical_health" {
  depends_on = [proxmox_virtual_environment_vm.infisical]
  url = "${var.infisical_hostname}/api/status"

  retry {
    attempts     = 10
    min_delay_ms = 5000
  }

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Infisical is not reachable"
    }
  }
}

resource "infisical_project" "kubernetes_project" {
  depends_on = [data.http.infisical_health]
  name        = "kubernetes-secrets"
  slug        = "kubernetes-secrets"
  type        = "secret-manager"
}


resource "infisical_identity" "eso" {
  name   = "external-secrets-operator"
  role   = "no-access"
  org_id = var.infisical_org_id
}

resource "infisical_project_identity" "eso" {
  project_id  = infisical_project.kubernetes_project.id
  identity_id = infisical_identity.eso.id
  roles = [
    {
      role_slug = "viewer"
    }
  ]
}

resource "infisical_secret" "cloudflare_token" {
  name         = "cloudflare_token"
  env_slug     = "prod"
  workspace_id = infisical_project.kubernetes_project.id
  value_wo = var.infisical_cloudflare_token
  value_wo_version = 1
  folder_path  = "/"
  lifecycle {
    prevent_destroy = true
  }
}

resource "infisical_secret" "proxmox_csi_token" {
  name         = "proxmox_csi_token"
  env_slug     = "prod"
  workspace_id = infisical_project.kubernetes_project.id
  value_wo = split("=", proxmox_virtual_environment_user_token.csi.value)[1]
  value_wo_version = 1
  folder_path  = "/"
    lifecycle {
    prevent_destroy = true
  }
}

data "kubernetes_secret_v1" "token_reviewer" {
  depends_on = [kubectl_manifest.token_reviewer]
  metadata {
    name      = "infisical-token-reviewer-token"
    namespace = "infisical-auth"
  }
}

resource "infisical_identity_kubernetes_auth" "this" {
  identity_id               = infisical_identity.eso.id
  kubernetes_host           = "https://${module.k8s_cluster.control_plane_ip}:6443"
  token_reviewer_jwt        = data.kubernetes_secret_v1.token_reviewer.data["token"]
  kubernetes_ca_certificate = trimspace(data.kubernetes_secret_v1.token_reviewer.data["ca.crt"])
  allowed_namespaces            = ["external-secrets"]
  allowed_service_account_names = ["external-secrets"]
  access_token_ttl              = 2592000
  access_token_max_ttl          = 2592000
  token_reviewer_mode = "api"
}