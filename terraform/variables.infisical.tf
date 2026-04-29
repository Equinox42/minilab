variable "infisical_cpu" {
  description = "CPU allocated to the Infisical VM"
  type        = number
  default = 2
}

variable "infisical_memory" {
  description = "Memory allocated to the Infisical VM"
  type        = number
  default = "4"
}

variable "infisical_disksize" {
  description = "Disk size of the Infisical VM"
  type        = string
}
variable "infisical_ip_adress" {
  description = "IP Address of Infisical VM"
  type        = string
}