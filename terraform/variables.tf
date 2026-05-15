variable "api_token" {
  description = "Proxmox API token for authentication"
  type        = string
  sensitive   = true
}

variable "proxmox_endpoint" {
  description = "Proxmox API endpoint"
  type        = string
}

variable "proxmox_node" {
  description = "Name of the proxmox node where VMs will be deployed"
  type        = string
}

variable "template_id" {
  description = "Template VM ID to clone"
  type        = number
}

variable "ssh_key" {
  description = "SSH public key to inject into the VM"
  type        = string
  sensitive   = true
}

variable "datastore" {
  description = "Datastore for VM disks"
  type        = string
  default     = "local"
}

variable "gateway" {
  description = "Default IPv4 gateway"
  type        = string
}

variable "username" {
  type = string
}

variable "datastore_id" {
  description = "Proxmox datastore for VM disks"
  type        = string
  default     = "local-lvm"
}

variable "nameservers" {
  type    = list(string)
  default = ["1.1.1.1", "8.8.8.8"]
}

variable "virtual_machines" {
  type = map(object({
    name      = string
    ip        = string
    cpu       = number
    memory    = number
    disk_size = optional(number, 30)
  }))
}