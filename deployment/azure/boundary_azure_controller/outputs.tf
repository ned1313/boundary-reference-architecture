# These outputs are used by the Boundary terraform config as inputs
# to perform the initial configuration of Boundary

output "vault_name" {
  value = local.vault_name
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "url" {
  value = "https://${azurerm_public_ip.boundary.fqdn}:9200"
}

output "client_id" {
  value = azuread_service_principal.recovery_sp.application_id
}

output "client_secret" {
  value = random_password.recovery_sp.result
}

output "ssh_public_key" {
  value = tls_private_key.boundary.public_key_openssh
}

output "worker_subnet_id" {
  value = module.vnet.vnet_subnets[1]
}

output "worker_vnet_id" {
  value = module.vnet.vnet_id
}

output "worker_vnet_tag" {
  value = "${data.azurerm_client_config.current.subscription_id} ${azurerm_resource_group.boundary.name}"
}

output "target_subnet_id" {
  value = module.vnet.vnet_subnets[2]
}

output "controller_fqdn" {
  value = azurerm_public_ip.boundary.fqdn
}

output "resource_group_name" {
  value = azurerm_resource_group.boundary.name
}

output "boundary_version" {
  value = var.boundary_version
}

output "worker_identity_id" {
  value = azurerm_user_assigned_identity.worker.id
}