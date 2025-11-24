resource "proxmox_virtual_environment_vm" "gitea" {
  name     = "gitea"
  description = "gitea server managed by terraform"
  node_name   = var.proxmox_host
  started     = true
  
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

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    file_format  = "raw"
    size         = "20"
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.gitea_host_ip
        gateway = var.gateway
      }
    }
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  user_account {
    username = var.username
    keys     = [var.ssh_key]
    }   
}
