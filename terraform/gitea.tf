resource "proxmox_virtual_environment_vm" "gitea" {
  name        = "gitea"
  description = "Managed by Terraform"
  tags        = ["gitea", "debian"]
  node_name   = var.proxmox_hostname

  clone {
    vm_id = var.id_template
  }

  cpu {
    cores = var.gitea_host_cpu
    type  = "host"
    numa  = false
  }

  memory {
    dedicated = var.gitea_host_mem
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  disk {
    datastore_id = "local-lvm"
    file_format  = "raw"
    interface    = "scsi0"
    size         = "20"
  }

  operating_system {
    type = "l26"
  }

  agent {
    enabled = false
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.gitea_host_ip
        gateway = var.gateway
      }
    }

    user_account {
      username = var.username
      keys     = [var.ssh_key]
    }
  }
}
