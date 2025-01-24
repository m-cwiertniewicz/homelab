terraform {
   cloud {
    organization = "projectMC"
    workspaces {
      name = "minikube"
     }
   }

  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "~> 0.70.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  username  = var.proxmox_username
  password  = var.proxmox_password
  insecure  = true
  ssh {
    private_key = file("/home/runner/.ssh/id_rsa")
    agent    = true
  }
}

resource "proxmox_virtual_environment_vm" "minikube_vm" {
  name        = "minikube"
  description = "Managed by Terraform"
  tags        = ["k8s"]

  node_name = "proxmox"
  vm_id     = 200

  agent {
    enabled = false
  }
  
  stop_on_destroy = true

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  cpu {
    cores        = 2
    type         = "x86-64-v2-AES"
  }

  memory {
    dedicated = 4096
  }

  disk {
    datastore_id = "data_disk"
    file_id      = proxmox_virtual_environment_download_file.latest_ubuntu_24_noble_qcow2_img.id
    interface    = "scsi0"
    size         = 10
  }

  initialization {
    ip_config {
      ipv4 {
        address = "192.168.10.200/24"
        gateway = "192.168.10.1"
      }
    }

    dns{
      servers = ["192.168.10.111"]
    }

    user_account {
      username = "minikube"
      password = var.minikube_password
      keys     = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2TZkaQvdzlLVPUIM5vBmu7Dt5/LwxdBMwmMQKJ6iWVsrmyyWc6kEzIckyTG+mL54fWtis/aIRJJSn94js7X9Xs44vmdb8FgwBGXPBvtkpI/nkVWnJvEbPTWgNH5CmQ+iza4dh7ttS+kgsp99x1lXUESf9Qy9Khhd0bENeisLZGc3SToxhjusJlIFNNPxuyh25sp5EgXsTp5EqRlgnQYI8+wPPZid/DvGVwSoWTDldeixp+vCQFRTL2evCJiidqJu9Q/d4YrAVeEn4Q1eAyr6kMT6Zun79+is8Nkc3Ep6rUe3iP5rPioDQ6oQYKngOnneT/KvsC7AoyWHLCHWjPeK/MSGvXjyXPxWpZFAnEwhl7/1bcjBRj0RBfHoIORdLuU5k7rUUQACS/Gkf2qXAV+bbBYaPfWqRn3CJtIC+6r0XFRXJqbcxgcLsFqjNgaf5J+pP7Te82dH+tmxUh0ERpqmk+H81/ltghPpOqkRtHwTXQkCtmzMJwbnLnqjMxHXeoDjgZdoXoDCbAo54EJbndZlHx90SvXW+d6HvbRXx7oszyAEbWvBnXFVTjRFyku7IuLeGQI/SwOOgszaqlmxilHomcRe65ussGrNMMyn9VCeuBhELD24AZVUTll2kEKma0AVC90J9KHcAGJqd/usm8752ErG4PXNBQA9KQj5KrXrHXw== deploy@key"]
    }
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }
}

resource "proxmox_virtual_environment_download_file" "latest_ubuntu_24_noble_qcow2_img" {
  content_type = "iso"
  datastore_id = "local"
  file_name    = "ubuntu-24-12-amd64-24012025.img"
  node_name    = "proxmox"
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}