variable "api_token" {
  description = "Proxmox API token for authentication"
  type        = string
  sensitive   = true
}

variable "proxmox_endpoint" {
  description = "Proxmox API endpoint"
  type        = string
}

variable "proxmox_hostname" {
  description = "Target Proxmox node where VMs will be deployed"
  type        = string
  default     = "proxmox"
}

variable "id_template" {
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
  default     = "192.168.1.1"
}
