variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "proxmox_node" {
  description = "Proxmox node where VMs will be deployed"
  type        = string
}

variable "kubernetes_nodes" {
  description = <<-EOF
    Map of Kubernetes nodes to provision. Key is the node name.
    Example:
      kubernetes_nodes = {
        "control-plane" = { ip = "10.0.0.10", cpu = 2, memory = 4096, role = "controller" }
        "worker-1"      = { ip = "10.0.0.11", cpu = 4, memory = 8192, role = "worker" }
        "worker-2"      = { ip = "10.0.0.12", cpu = 4, memory = 8192, role = "worker" }
        ...
      }
  EOF
    type = map(object({
    ip        = string
    cpu       = number
    memory    = number
    role      = string
    disk_size = optional(number, 50)
  }))

  validation {
    condition = alltrue([
      for node in var.kubernetes_nodes : contains(["controller", "worker"], node.role)
    ])
    error_message = "Each node role must be either 'controller' or 'worker'."
  }

  validation {
    condition = alltrue([
      for node in var.kubernetes_nodes : node.cpu >= 2 && node.memory >= 2048
    ])
    error_message = "Each node must have at least 2 CPUs and 2048 MB of memory."
  }

  validation {
    condition     = length([for n in var.kubernetes_nodes : n if n.role == "controller"]) >= 1
    error_message = "At least one controller node is required."
  }
}
variable "template_id" {
  description = "Template VM ID to clone"
  type = number
}

variable "ssh_key" {
  description = "SSH public key to inject into the VM"
  type      = string
  sensitive = true
}

variable "username" {
  description = "Username for SSH access to the nodes"
  type        = string
}

variable "gateway" {
  description = "IP of the gateway"
  type = string
}

variable "datastore_id" {
  description = "Proxmox datastore for VM disks"
  type        = string
  default     = "local-lvm"
}

variable "extra_tags" {
  description = "Additional tags to apply to VMs"
  type        = list(string)
  default     = []
}