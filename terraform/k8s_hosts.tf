resource "proxmox_virtual_environment_vm" "k8s_hosts" {
  for_each = local.k8s_nodes
  name     = "k8s-${each.key}"
  description = "Kubernetes nodes managed by Terraform"
    tags        = ["kubernetes", "debian"]
  node_name   = var.proxmox_hostname
  started     = true
  
  clone {
    vm_id = var.id_template
  }

  agent {
    enabled = false
  }

  cpu {
    cores = each.value.cpu
    type  = "host" 
    numa  = false
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    file_format  = "raw"
    size         = "50"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"
        gateway = var.gateway
      }
    }

    user_account {
      username = var.username
      keys = [var.ssh_key] 
    }
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }
}
