variable "environment" {
  description = "cluster environment"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be dev or prod."
  }
}

variable "proxmox_node" {
  description = "Proxmox node where VMs will be deployed"
  type        = string
}

variable "kubernetes_nodes" {
  description = "Nodes Configuration"
  type = map(object({
    ip     = string
    cpu    = number
    memory = number
  }))

  validation {
    condition = alltrue([
      for node in var.kubernetes_nodes : node.cpu >= 2 && node.memory >= 2048
    ])
    error_message = "Each nodes must have at least 2 cpu and 2048 memory allocated"
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
  description = "user of the nodes"
  type = string
}

variable "gateway" {
  description = "IP of the gateway"
  type = string
}

variable "datastore_id" {
  type    = string
  default = "local-lvm"
}

variable "extra_tags" {
  description = "extra tags to classify the nodes"
  type    = list(string)
  default = []
}