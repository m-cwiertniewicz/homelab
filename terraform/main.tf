terraform {
   cloud {
    organization = "projectMC"

    workspaces {
      name = "proxmox-workspace"
     }
   }

  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "~> 0.69.1"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  username  = var.proxmox_username
  password  = var.proxmox_password
  insecure  = true
  ssh {
    agent    = true
  }
}
