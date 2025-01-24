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

variable "minikube_password" {
  description = "Minikube password"
  type        = string
  sensitive   = true
}