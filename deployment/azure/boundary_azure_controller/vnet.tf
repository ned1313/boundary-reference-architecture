# Define provider for config
provider "azurerm" {
  features {}
}

# Used to get tenant ID as needed
data "azurerm_client_config" "current" {}

# Resource group for ALL resources
resource "azurerm_resource_group" "boundary" {
  name     = local.resource_group_name
  location = var.location
}

# Virtual network with three subnets for controller, workers, and backends
module "vnet" {
  source              = "Azure/vnet/azurerm"
  version             = "~> 2.0"
  resource_group_name = azurerm_resource_group.boundary.name
  vnet_name           = azurerm_resource_group.boundary.name
  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  subnet_names        = var.subnet_names

  # Service endpoints used for Key Vault and Postgres DB access
  # Only the controller subnet needs DB access
  subnet_service_endpoints = {
    (var.subnet_names[0]) = ["Microsoft.Sql"]
  }
}

# Create Network Security Group for controller subnet
resource "azurerm_network_security_group" "controller_net" {
  name                = local.controller_net_nsg
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
}

# Create NSG association
resource "azurerm_subnet_network_security_group_association" "controller" {
  subnet_id                 = module.vnet.vnet_subnets[0]
  network_security_group_id = azurerm_network_security_group.controller_net.id
}

# Create Network Security Groups for controller NICs
# The associations are in the vm.tf file

resource "azurerm_network_security_group" "controller_nics" {
  name                = local.controller_nic_nsg
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
}

# Create application security groups for controllers
# The associations are in the vm.tf file

resource "azurerm_application_security_group" "controller_asg" {
  name                = local.controller_asg
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
}