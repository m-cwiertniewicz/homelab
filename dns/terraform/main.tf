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
  ipv4_address           = "192.168.10.111/24"
  ipv4_gateway           = "192.168.10.1"
  dns                    = ["192.168.10.1"]
  memory_dedicated       = 1024
  template_file_id       = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
  os_type                = "debian"
  datastore_id           = "data_disk"
  disk_size              = 10
  tags                   = ["dns"]
  ssh_keys               = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2TZkaQvdzlLVPUIM5vBmu7Dt5/LwxdBMwmMQKJ6iWVsrmyyWc6kEzIckyTG+mL54fWtis/aIRJJSn94js7X9Xs44vmdb8FgwBGXPBvtkpI/nkVWnJvEbPTWgNH5CmQ+iza4dh7ttS+kgsp99x1lXUESf9Qy9Khhd0bENeisLZGc3SToxhjusJlIFNNPxuyh25sp5EgXsTp5EqRlgnQYI8+wPPZid/DvGVwSoWTDldeixp+vCQFRTL2evCJiidqJu9Q/d4YrAVeEn4Q1eAyr6kMT6Zun79+is8Nkc3Ep6rUe3iP5rPioDQ6oQYKngOnneT/KvsC7AoyWHLCHWjPeK/MSGvXjyXPxWpZFAnEwhl7/1bcjBRj0RBfHoIORdLuU5k7rUUQACS/Gkf2qXAV+bbBYaPfWqRn3CJtIC+6r0XFRXJqbcxgcLsFqjNgaf5J+pP7Te82dH+tmxUh0ERpqmk+H81/ltghPpOqkRtHwTXQkCtmzMJwbnLnqjMxHXeoDjgZdoXoDCbAo54EJbndZlHx90SvXW+d6HvbRXx7oszyAEbWvBnXFVTjRFyku7IuLeGQI/SwOOgszaqlmxilHomcRe65ussGrNMMyn9VCeuBhELD24AZVUTll2kEKma0AVC90J9KHcAGJqd/usm8752ErG4PXNBQA9KQj5KrXrHXw== deploy@key"]
}