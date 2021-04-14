# Inbound rules for worker subnet nsg

resource "azurerm_network_security_rule" "worker_9202" {
  name                                       = "allow_9202"
  priority                                   = 100
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "Tcp"
  source_port_range                          = "*"
  destination_port_range                     = "9202"
  source_address_prefix                      = "*"
  destination_application_security_group_ids = [azurerm_application_security_group.worker_asg.id]
  resource_group_name                        = azurerm_resource_group.boundary.name
  network_security_group_name                = azurerm_network_security_group.worker_net.name
}

resource "azurerm_network_security_rule" "worker_ssh" {
  name                                       = "allow_ssh"
  priority                                   = 110
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "Tcp"
  source_port_range                          = "*"
  destination_port_range                     = "22"
  source_address_prefix                      = "*"
  destination_application_security_group_ids = [azurerm_application_security_group.worker_asg.id]
  resource_group_name                        = azurerm_resource_group.boundary.name
  network_security_group_name                = azurerm_network_security_group.worker_net.name
}

# Inbound rules for worker nic nsg

resource "azurerm_network_security_rule" "worker_nic_9202" {
  name                                       = "allow_9202"
  priority                                   = 100
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "Tcp"
  source_port_range                          = "*"
  destination_port_range                     = "9202"
  source_address_prefix                      = "*"
  destination_application_security_group_ids = [azurerm_application_security_group.worker_asg.id]
  resource_group_name                        = azurerm_resource_group.boundary.name
  network_security_group_name                = azurerm_network_security_group.worker_nics.name
}

resource "azurerm_network_security_rule" "worker_nic_ssh" {
  name                                       = "allow_ssh"
  priority                                   = 110
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "Tcp"
  source_port_range                          = "*"
  destination_port_range                     = "22"
  source_address_prefix                      = "*"
  destination_application_security_group_ids = [azurerm_application_security_group.worker_asg.id]
  resource_group_name                        = azurerm_resource_group.boundary.name
  network_security_group_name                = azurerm_network_security_group.worker_nics.name
}