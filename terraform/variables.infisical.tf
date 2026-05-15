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
  type        = string
  sensitive   = true
}

variable "infisical_cloudflare_token" {
  description = "cloudflare token value that will be stored in the vault"
  type        = string
  sensitive   = true
}