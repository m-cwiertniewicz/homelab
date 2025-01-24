output "vm_ip" {
  value = proxmox_virtual_environment_vm.minikube_vm.initialization[0].ip_config[0].ipv4[0].address
}