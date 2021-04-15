resource "azurerm_availability_set" "worker" {
  name                         = local.worker_vm
  location                     = var.location
  resource_group_name          = azurerm_resource_group.boundary.name
  platform_fault_domain_count  = 3
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_network_interface" "worker" {
  count               = var.worker_vm_count
  name                = "${local.worker_vm}-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Associate the network interfaces from the workers with the worker NSG
resource "azurerm_network_interface_security_group_association" "worker" {
  count                     = var.worker_vm_count
  network_interface_id      = azurerm_network_interface.worker[count.index].id
  network_security_group_id = azurerm_network_security_group.worker_nics.id
}

# Associate the network interfaces from the workers with the worker ASG for NSG rules
resource "azurerm_network_interface_application_security_group_association" "worker" {
  count                         = var.worker_vm_count
  network_interface_id          = azurerm_network_interface.worker[count.index].id
  application_security_group_id = azurerm_application_security_group.worker_asg.id
}

resource "azurerm_linux_virtual_machine" "worker" {
  count               = var.worker_vm_count
  name                = "${local.worker_vm}-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
  size                = var.worker_vm_size
  admin_username      = "azureuser"
  computer_name       = "worker-${count.index}"
  availability_set_id = azurerm_availability_set.worker.id
  network_interface_ids = [
    azurerm_network_interface.worker[count.index].id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.public_key
  }

  # Using Standard SSD tier storage
  # Accepting the standard disk size from image
  # No data disk is being used
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  #Source image is hardcoded b/c I said so
  source_image_reference {
    publisher = var.worker_image["publisher"]
    offer     = var.worker_image["offer"]
    sku       = var.worker_image["sku"]
    version   = var.worker_image["version"]
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.identity_id]
  }

  secret {
    key_vault_id = data.azurerm_key_vault.boundary.id

    certificate {
      url = azurerm_key_vault_certificate.boundary.secret_id
    }
  }

  custom_data = base64encode(
    templatefile("${path.module}/boundary.tmpl", {
      vault_name       = var.vault_name
      type             = "worker"
      name             = "boundary"
      boundary_version = var.boundary_version
      tenant_id        = var.tenant_id
      public_ip        = azurerm_public_ip.boundary.fqdn
      controller_ips   = var.controller_ips
      db_username      = "none"
      db_password      = "none"
      db_name          = "none"
      db_endpoint      = "none"
      region = var.location
      cloud = "azure"
      network_id = var.worker_vnet_tag
    })
  )

}