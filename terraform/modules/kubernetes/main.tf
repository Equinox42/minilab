resource "proxmox_virtual_environment_vm" "kubernetes_nodes" {
  for_each = var.kubernetes_nodes


  name = "${var.cluster_name}-${each.key}"
  description = "Kubernetes node for ${var.cluster_name} cluster - managed by Terraform"
  tags = concat(["k0s", "debian", var.cluster_name, each.value.role], var.extra_tags)
  node_name   = var.proxmox_node
  started     = true

  stop_on_destroy = true

  clone {
    vm_id = var.template_id
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
    datastore_id = var.datastore_id
    interface    = "scsi0"
    file_format  = "raw"
    size         = each.value.disk_size
  }
  agent {
   enabled = false
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
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  lifecycle {
    ignore_changes = [description]
  }
}
