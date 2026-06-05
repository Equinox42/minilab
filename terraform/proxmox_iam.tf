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

// Image Builder

resource "proxmox_virtual_environment_role" "image_builder" {
  role_id = "image_builder"
  privileges = [
    # Datastore.*
    "Datastore.Allocate",
    "Datastore.AllocateSpace",
    "Datastore.AllocateTemplate",
    "Datastore.Audit",
    # SDN.*
    "SDN.Allocate",
    "SDN.Audit",
    "SDN.Use",
    # Sys.*
    "Sys.AccessNetwork",
    "Sys.Audit",
    # VM.*
    "VM.Allocate",
    "VM.Audit",
    "VM.Backup",
    "VM.Clone",
    "VM.Config.CDROM",
    "VM.Config.CPU",
    "VM.Config.Cloudinit",
    "VM.Config.Disk",
    "VM.Config.HWType",
    "VM.Config.Memory",
    "VM.Config.Network",
    "VM.Config.Options",
    "VM.Console",
    "VM.GuestAgent.Audit",
    "VM.GuestAgent.FileRead",
    "VM.GuestAgent.FileSystemMgmt",
    "VM.GuestAgent.FileWrite",
    "VM.GuestAgent.Unrestricted",
    "VM.Migrate",
    "VM.PowerMgmt",
    "VM.Replicate",
    "VM.Snapshot",
    "VM.Snapshot.Rollback",
  ]
}

resource "proxmox_virtual_environment_user" "image_builder" {
  acl {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.image_builder.role_id
  }

  comment = "imagebuilder"
  user_id = "imagebuilder@pve"
}

resource "proxmox_user_token" "image_builder" {
  comment    = "image builder"
  token_name = "imagebuilder"
  user_id    = proxmox_virtual_environment_user.image_builder.user_id
  privileges_separation = false
}

// Cluster API Proxmox

resource "proxmox_virtual_environment_user" "capmox" {
  user_id = "capmox@pve"
  comment = "ClusterAPI Proxmox"

  acl {
    path      = "/"
    propagate = true
    role_id   = "PVEVMAdmin"
  }
}

resource "proxmox_user_token" "capmox" {
  comment    = "ClusterAPI Proxmox"
  token_name = "capmox"
  user_id    = proxmox_virtual_environment_user.capmox.user_id
  privileges_separation = true 
}
