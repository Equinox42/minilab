resource "proxmox_virtual_environment_vm" "virtual_machines" {
  for_each = var.virtual_machines

  name        = each.value.name
  description = "each.value.name - managed by Terraform"
  tags        = [each.value.name]
  node_name   = var.proxmox_node
  started     = true

  clone {
    vm_id = var.template_id
  }

  cpu {
    cores = each.value.cpu
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = var.datastore_id
    interface    = "scsi0"
    file_format  = "raw"
    size         = each.value.disk_size
  }
  agent {
    enabled = true
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
      keys     = [var.ssh_key]
    }
    dns {
      servers = var.nameservers
    }
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }
}
