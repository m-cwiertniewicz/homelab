variable "proxmox_endpoint" {
  description = "Proxmox endpoint address"
  type        = string
  sensitive   = true
}

variable "proxmox_username" {
  description = "Proxmox username"
  type        = string
  sensitive   = true
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

variable "dns01_password" {
  description = "DNS01 password"
  type        = string
  sensitive   = true
}