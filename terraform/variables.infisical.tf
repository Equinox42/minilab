variable "infisical_cpu" {
  description = "CPU allocated to the Infisical VM"
  type        = number
  default     = 2
}

variable "infisical_memory" {
  description = "Memory allocated to the Infisical VM"
  type        = number
  default     = "4"
}

variable "infisical_disksize" {
  description = "Disk size of the Infisical VM"
  type        = string
}
variable "infisical_ip_adress" {
  description = "IP Address of Infisical VM"
  type        = string
}

variable "infisical_hostname" {
  description = "infisical fqdn"
  type        = string
}

variable "infisical_client_id" {
  type      = string
  sensitive = true
}

variable "infisical_client_secret" {
  type      = string
  sensitive = true
}

variable "infisical_org_id" {
  description = "infisical organization ID"
  type      = string
  sensitive = true
}

variable "infisical_cloudflare_token" {
  description = "cloudflare token value that will be stored in the vault"
  type = string
  sensitive = true
}