output "container_ip" {
  value = proxmox_virtual_environment_container.container.initialization[0].ip_config[0].ipv4[0].address
}