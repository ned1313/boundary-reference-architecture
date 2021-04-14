output "target_ips" {
  value = azurerm_network_interface.backend[*].private_ip_address
}

output "target_tags" {
  value = {
    cloud = "Azure"
    region = var.location
    network_id = replace(var.subnet_id, "/\\/subnets\\/.*/","")
  }
}