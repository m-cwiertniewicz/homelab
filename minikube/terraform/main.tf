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
      keys     = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrVGKTNlZBW+lhaIopn1R/Bg08NhifbR4njGAnO6XWGggzXhPwrbrIbzwG4vlwcP1CiwwVB6oeCuJQQpV516KVAt8q8hmZUslIeMseF+r+GiAoDdDGKriwWSs30dOYqVEpMD2xNMByOK4UhgTBcLjXFj1S+cT5YnbHLLbid6d8GjQ7ZCuKftL+JO7t5Ylsex8cSFsBVb+s/FyxxhyK2mpj2VzhgrgXf2xY6iq+ZGHfjyM5RCmRZgDOV+tWFc3iCyNPbW86boh+Sj7VHVfdUUmm3T/e5yjO+LCG6vrC/Z4K8KwMJy6FOS/e+zIHBHaNzY2PUHiGSvM4WBVu5EDKFt4OnSjSmzeJHkE4dqTNdbb0g9zphRUjaHKXIyjmTwT/tXl4eCEkuNx/zY17f4qCUgseIvNc4kGfmGaRrNhTwkLnl8Z6rCVyHCLKK3rN0bL/xuhBK9mOZMQWVxN3Qm3mrFNbUwh7R6YW+FBHTX3pprsFvT4WrtfM+2mMe0aD3cl4Hs9FelYrLK7wB8YfljmcE1xzKBgTADnaB5Rn4MmHjiu6xY0ytM4oHfIuHDJXlo/zDhhkJNstrr23Xn0gjwqKyAnYxB/YtazOLW+cME46txistbJIu0TlbOKW7koy7ApqdeshKMeyVq4FCp60XEUQUBhw0ZCxa/fcNFJERj/yCLGIYQ== k8s@deploy"]
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