variable "boundary_version" {
  type    = string
  default = "0.1.8"
}

module "controller" {
  source              = "./boundary_azure_controller"
  controller_vm_count = 1
  boundary_version    = var.boundary_version
}

module "worker" {
  source              = "./boundary_azure_controller"
  worker_vm_count = 1
  subnet_id = module.controller.subnet_id
  controller_resource_group_name = module.controller.resource_group_name
  public_key = module.controller.ssh_public_key
  identity_id = module.controller.worker_identity_id
  boundary_version = var.boundary_version
  vault_name = module.controller.vault_name
  tenant_id = module.controller.tenant_id
  controller_ips = module.controller.controller_fqdn
}

module "boundary" {
  source        = "./boundary"
  url           = module.azure.url
  target_ips    = module.azure.target_ips
  tenant_id     = module.azure.tenant_id
  client_id     = module.azure.client_id
  client_secret = module.azure.client_secret
  vault_name    = module.azure.vault_name
}

output "url" {
  value = module.azure.url
}