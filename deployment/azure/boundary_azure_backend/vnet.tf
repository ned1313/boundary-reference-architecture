# Create Network Security Groups for subnets
resource "azurerm_network_security_group" "backend_net" {
  name                = local.backend_net_nsg
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
}

# Create NSG associations
resource "azurerm_subnet_network_security_group_association" "backend" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.backend_net.id
}

# Create Network Security Groups for NICs
resource "azurerm_network_security_group" "backend_nics" {
  name                = local.backend_nic_nsg
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
}

# Create application security groups for backend
resource "azurerm_application_security_group" "backend_asg" {
  name                = local.backend_asg
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
}