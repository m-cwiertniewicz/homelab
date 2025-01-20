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

module "lxc_dns01" {
  source                 = "./modules/lxc"
  node_name              = "proxmox"
  hostname               = "dns01"
  password               = var.dns01_password
  ipv4_address           = "dhcp"
  memory_dedicated       = 1024
  template_file_id       = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
  os_type                = "debian"
  datastore_id           = "data_disk"
  disk_size              = 10
  tags                   = ["dns"] 
}