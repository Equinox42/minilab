data "http" "infisical_health" {
  depends_on = [proxmox_virtual_environment_vm.virtual_machines]
  url        = "${var.infisical_hostname}/api/status"

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
  name       = "kubernetes-secrets"
  slug       = "kubernetes-secrets"
  type       = "secret-manager"
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
  name             = "cloudflare_token"
  env_slug         = "prod"
  workspace_id     = infisical_project.kubernetes_project.id
  value_wo         = var.infisical_cloudflare_token
  value_wo_version = 1
  folder_path      = "/"
  lifecycle {
    prevent_destroy = true
  }
}

resource "infisical_secret" "proxmox_csi_token" {
  name             = "proxmox_csi_token"
  env_slug         = "prod"
  workspace_id     = infisical_project.kubernetes_project.id
  value_wo         = split("=", proxmox_user_token.csi.value)[1]
  value_wo_version = 2
  folder_path      = "/"
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
  identity_id                   = infisical_identity.eso.id
  kubernetes_host               = "https://${module.k8s_cluster.control_plane_ip}:6443"
  token_reviewer_jwt            = data.kubernetes_secret_v1.token_reviewer.data["token"]
  kubernetes_ca_certificate     = trimspace(data.kubernetes_secret_v1.token_reviewer.data["ca.crt"])
  allowed_namespaces            = ["external-secrets"]
  allowed_service_account_names = ["external-secrets"]
  access_token_ttl              = 2592000
  access_token_max_ttl          = 2592000
  token_reviewer_mode           = "api"
}

