resource "proxmox_virtual_environment_vm" "infisical" {


  name = "Infisical"
  description = "Infisical - Vault for Secrets"
  tags = concat(["Infisical"])
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
    ignore_changes = [description]
    prevent_destroy = true
  }
}

