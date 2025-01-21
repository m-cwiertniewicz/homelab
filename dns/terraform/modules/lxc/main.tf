terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "~> 0.69.1"
    }
  }
}

resource "proxmox_virtual_environment_container" "container" {
  description = "Managed by Terraform"
  node_name = var.node_name
  tags = var.tags

  cpu {
    cores = var.cpu_cores
  }

  initialization {
    hostname = var.hostname
    user_account {
      password = var.password
      keys     = var.ssh_keys
    }

    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_gateway
      }
    }
    
    dns {
      domain  = "domain.name"
      servers = var.dns
    }
  }

  memory {
    dedicated = var.memory_dedicated
  }

  network_interface {
    name   = var.network_interface_name
    bridge = var.network_bridge
  }

  operating_system {
    template_file_id = var.template_file_id
    type             = var.os_type
  }

  disk {
    datastore_id = var.datastore_id
    size         = var.disk_size
  }

}