# Create Network Security Groups for subnets

resource "azurerm_network_security_group" "worker_net" {
  name                = local.worker_net_nsg
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
}


# Create NSG associations

resource "azurerm_subnet_network_security_group_association" "worker" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.worker_net.id
}

# Create Network Security Groups for NICs
# The associations are in the vm.tf file

resource "azurerm_network_security_group" "worker_nics" {
  name                = local.worker_nic_nsg
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
}

# Create application security groups for workers
# The associations are in the vm.tf file

resource "azurerm_application_security_group" "worker_asg" {
  name                = local.worker_asg
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
}