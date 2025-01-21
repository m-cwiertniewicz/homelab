variable "node_name" {
  description = "The name of the Proxmox node where the container is created"
  type        = string
}

variable "hostname" {
  description = "The hostname of the container"
  type        = string
}

variable "password" {
  description = "The root user's password for the container"
  type        = string
  sensitive   = true
}

variable "ipv4_address" {
  description = "The IPv4 address of the container (e.g., 'dhcp' or '192.168.1.100/24')"
  type        = string
  default     = "dhcp"
}

variable "ipv4_gateway" {
  description = "The IPv4 gateway of the container"
  type        = string
}

variable "memory_dedicated" {
  description = "The dedicated amount of RAM (in MB)"
  type        = number
  default     = 1024
}

variable "network_interface_name" {
  description = "The name of the network interface (e.g., 'eth0')"
  type        = string
  default     = "eth0"
}

variable "dns" {
  description = "The DNS servers for the container"
  type        = list(string)
}

variable "network_bridge" {
  description = "The network bridge (e.g., 'vmbr0')"
  type        = string
  default     = "vmbr0"
}

variable "template_file_id" {
  description = "The path to the operating system template (e.g., 'local:vztmpl/debian-12-standard.tar.zst')"
  type        = string
}

variable "os_type" {
  description = "The type of the operating system (e.g., 'debian')"
  type        = string
  default     = "debian"
}

variable "datastore_id" {
  description = "The ID of the storage/datastore for the container's disk"
  type        = string
}

variable "disk_size" {
  description = "The size of the disk in GB"
  type        = number
  default     = 10
}

variable "tags" {
  description = "The tags for the container"
  type        = list(string)
}

variable "ssh_keys" {
  description = "The SSH public keys for the container"
  type        = list(string)
}