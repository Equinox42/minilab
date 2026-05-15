variable "kubernetes_nodes" {
  type = map(object({
    ip        = string
    cpu       = number
    memory    = number
    disk_size = optional(number, 50)
    role      = string
  }))
}
variable "k0s_version" {
  description = "Version of k0s to deploy"
  type        = string
  default     = "v1.34.2+k0s.0"
}
variable "ssh_private_key_path" {
  description = "path to private key used by k0sctl for boostraping kubernetes cluster"
  type        = string
}

variable "proxmox_csi_region" {
  description = "Proxmox cluster name used as the topology region label for the Proxmox CSI driver (topology.kubernetes.io/region)"
  type        = string
}

variable "proxmox_csi_zone" {
  description = "Proxmox node name used as the topology zone label for the Proxmox CSI driver (topology.kubernetes.io/zone)"
  type        = string
}

variable "kubeconfig_path" {
  description = "Path of the kubeconfig file"
  type        = string
}