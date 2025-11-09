resource "proxmox_virtual_environment_vm" "k0s" {
  for_each = local.k8s_nodes
  name     = "k8s-${each.key}"
  description = "Kubernetes nodes managed by Terraform"
  node_name   = var.proxmox_host
  started     = true
  
  clone {
    vm_id = var.id_template
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

#   Disque data 1 (OSD Ceph)
#   disk {
#     datastore_id = "local-lvm"
#     interface    = "scsi1"
#     file_format  = "raw"
#     size         = 50
#   }

  initialization {
    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"
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
