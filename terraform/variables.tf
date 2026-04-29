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
  type        = string
}
variable "kubernetes_nodes" {
  type = map(object({
    ip     = string
    cpu    = number
    memory = number
    role   = string  
  }))
}

variable "k0s_version" {
  description = "Version of k0s to deploy"
  type        = string
  default     = "v1.34.2+k0s.0"
}

variable "proxmox_csi_region" {
  description = "Proxmox cluster name used as the topology region label for the Proxmox CSI driver (topology.kubernetes.io/region)"
  type = string
}

variable "proxmox_csi_zone" {
  description = "Proxmox node name used as the topology zone label for the Proxmox CSI driver (topology.kubernetes.io/zone)"
  type = string
}

variable "ssh_private_key_path" {
  description = "path to private key used by k0sctl for boostraping kubernetes cluster"
  type = string
}

variable "metallb_adress_pool" {
  description = "Pool of ip addresses that will be used by metallb"
  type        = string
}

variable "kubeconfig_path" {
  description = "Path of the kubeconfig file"
  type        = string
}

variable "argocd_server_address" {
  description = "ArgoCD server hostname"
  type = string
}

variable "argocd_server_username" {
  type = string
}

variable "argocd_server_password" {
  type = string
  sensitive = true
}