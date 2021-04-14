# Inbound rules for backend subnet nsg

resource "azurerm_network_security_rule" "backend_net_22" {
  name                                       = "allow_ssh"
  priority                                   = 100
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "Tcp"
  source_port_range                          = "*"
  destination_port_range                     = "22"
  source_application_security_group_ids      = [var.worker_asg_id]
  destination_application_security_group_ids = [azurerm_application_security_group.backend_asg.id]
  resource_group_name                        = azurerm_resource_group.boundary.name
  network_security_group_name                = azurerm_network_security_group.backend_net.name
}

# Inbound rules for remote hosts

resource "azurerm_network_security_rule" "backend_nics_22" {
  name                                       = "allow_ssh"
  priority                                   = 100
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "Tcp"
  source_port_range                          = "*"
  destination_port_range                     = "22"
  source_application_security_group_ids      = [var.worker_asg_id]
  destination_application_security_group_ids = [azurerm_application_security_group.backend_asg.id]
  resource_group_name                        = azurerm_resource_group.boundary.name
  network_security_group_name                = azurerm_network_security_group.backend_nics.name
}