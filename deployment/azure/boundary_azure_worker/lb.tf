# Create a public IP address for the load balancer
# The domain label is based on the resource group name
resource "azurerm_public_ip" "boundary" {
  name                = local.pip_name
  resource_group_name = azurerm_resource_group.boundary.name
  location            = azurerm_resource_group.boundary.location
  allocation_method   = "Static"
  domain_name_label   = lower(azurerm_resource_group.boundary.name)
  sku                 = "Standard"
}

# Create a load balancer for the workers to use
resource "azurerm_lb" "boundary" {
  name                = local.lb_name
  location            = azurerm_resource_group.boundary.location
  resource_group_name = azurerm_resource_group.boundary.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.boundary.id
  }
}

# Create address pools for workers
resource "azurerm_lb_backend_address_pool" "pools" {
  loadbalancer_id = azurerm_lb.boundary.id
  name            = "workers"
}

# Associate all worker NICs with their backend pool
resource "azurerm_network_interface_backend_address_pool_association" "worker" {
  count                   = var.worker_vm_count
  backend_address_pool_id = azurerm_lb_backend_address_pool.pools.id
  ip_configuration_name   = "internal"
  network_interface_id    = azurerm_network_interface.worker[count.index].id
}

# All health probe for worker nodes
resource "azurerm_lb_probe" "worker_9202" {
  resource_group_name = azurerm_resource_group.boundary.name
  loadbalancer_id     = azurerm_lb.boundary.id
  name                = "port-9202"
  port                = 9202
}

# Add LB rule for the workers
resource "azurerm_lb_rule" "worker" {
  resource_group_name            = azurerm_resource_group.boundary.name
  loadbalancer_id                = azurerm_lb.boundary.id
  name                           = "Worker"
  protocol                       = "Tcp"
  frontend_port                  = 9202
  backend_port                   = 9202
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.worker_9202.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.pools.id
}

# Add an NAT rule for the worker node using port 2022
# This is so you can SSH into the controller to troubleshoot 
# deployment issues.
resource "azurerm_lb_nat_rule" "worker" {
  resource_group_name            = azurerm_resource_group.boundary.name
  loadbalancer_id                = azurerm_lb.boundary.id
  name                           = "ssh-worker"
  protocol                       = "Tcp"
  frontend_port                  = 2022
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}

# Associate the NAT rule with the first worker VM
resource "azurerm_network_interface_nat_rule_association" "worker" {
  network_interface_id  = azurerm_network_interface.worker[0].id
  ip_configuration_name = "internal"
  nat_rule_id           = azurerm_lb_nat_rule.worker.id
}
