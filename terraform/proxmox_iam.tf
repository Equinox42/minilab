// Proxmox CSI Configuration

resource "proxmox_virtual_environment_role" "csi" {
  role_id = "Kubernetes-CSI"

  privileges = [
    "VM.Audit",
    "VM.Config.Disk",
    "Datastore.Allocate",
    "Datastore.AllocateSpace",
    "Datastore.Audit",
  ]
}

resource "proxmox_virtual_environment_user" "kubernetes" {
  acl {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.csi.role_id
  }

  comment = "Kubernetes"
  user_id = "kubernetes-csi@pve"
}

resource "proxmox_user_token" "csi" {
  comment    = "Kubernetes CSI"
  token_name = "csi"
  user_id    = proxmox_virtual_environment_user.kubernetes.user_id
}

resource "proxmox_acl" "csi" {
  token_id = proxmox_user_token.csi.id
  role_id  = proxmox_virtual_environment_role.csi.role_id

  path      = "/"
  propagate = true
}

output "csi_token_value" {
  value     = proxmox_user_token.csi.value
  sensitive = true
}

// Homepage RO Configuration

resource "proxmox_virtual_environment_role" "homepage" {
  role_id = "Homepage"

  privileges = [
    "VM.Audit",
    "VM.GuestAgent.Audit",
    "Sys.Audit",
    "Datastore.Audit",
    "Mapping.Audit",
    "SDN.Audit"
  ]
}

resource "proxmox_virtual_environment_user" "homepage" {
  acl {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.homepage.role_id
  }

  comment = "Homepage"
  user_id = "homepage@pve"
}

resource "proxmox_user_token" "homepage" {
  comment    = "homepage api"
  token_name = "homepage"
  user_id    = proxmox_virtual_environment_user.homepage.user_id
  privileges_separation = true 
}

resource "proxmox_acl" "homepage" {
  token_id = proxmox_user_token.homepage.id
  role_id  = proxmox_virtual_environment_role.homepage.role_id

  path      = "/"
  propagate = true
}