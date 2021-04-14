variable "worker_vm_count" {
  default = 1
  description = "Number of workers to create"
  type = number
}

variable "location" {
  default = "eastus"
  description = "Region to create resources in Azure"
  type = string
}

variable "subnet_id" {
  description = "ID of Subnet for placement of workers"
  type = string
}

variable "vnet_id" {
  description = "VNet ID for placement of workers"
  type = string
}

variable "controller_resource_group_name" {
  description = "Resource group for controller resources"
  type = string
}

variable "worker_vm_size" {
  description = "Azure VM size for workers"
  default = "Standard_D2as_v4"
  type = string
}

variable "worker_image" {
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  type = map(string)
}

variable "public_key" {
  description = "Public key value to use for worker SSH"
  type = string
}

variable "identity_id" {
  description = "Azure Active Directory identity to use for Key Vault access"
}

variable "boundary_version" {
  description = "Version of Boundary to use, must match Controller version"
  type = string
}

variable "vault_name" {
  description = "Name of Key Vault used for certificate storage and Boundary keys"
  type = string
}

variable "cert_cn" {
  type    = string
  default = "boundary-azure-worker"
}

variable "tenant_id" {
  description = "Azure AD Tenant ID"
  type = string
}

variable "controller_ips" {
  description = "List of controller IP addresses or hostnames"
  type = list(string)
}

resource "random_id" "id" {
  byte_length = 4
}

locals {
  resource_group_name = "boundary-worker-${random_id.id.hex}"

  worker_net_nsg = "worker-net-${random_id.id.hex}"

  worker_nic_nsg = "worker-nic-${random_id.id.hex}"

  worker_asg = "worker-asg-${random_id.id.hex}"

  worker_vm = "worker-${random_id.id.hex}"

  pip_name = "boundary-worker-${random_id.id.hex}"
  lb_name  = "boundary-worker-${random_id.id.hex}"
  worker_domain_label = "boundary-worker-${random_id.id.hex}"

  vault_name = "boundary-${random_id.id.hex}"

  pg_name = "boundary-${random_id.id.hex}"

  sp_name = "boundary-${random_id.id.hex}"

  cert_san = ["boundary-worker-${random_id.id.hex}.${var.location}.cloudapp.azure.com"]

}
