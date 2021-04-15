output "target_ips" {
  value = azurerm_network_interface.backend[*].private_ip_address
}

output "target_tags" {
  value = {
    cloud = "azure"
    region = var.location
    network_id = "${split("/",var.subnet_id)[2]} ${split("/",var.subnet_id)[4]}"
  }
}