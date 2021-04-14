variable "backend_vm_count" {
  type    = number
  default = 1
}

variable "backend_vm_size" {
  type    = string
  default = "Standard_D2as_v4"
}

variable "location" {
  default = "eastus"
  description = "Region to create resources in Azure"
  type = string
}

variable "subnet_id" {
  description = "ID of Subnet for placement of backend"
  type = string
}

variable "worker_asg_id" {
  description = "ASG ID of workers that will connect to backend servers"
  type = string
}

variable "backend_image" {
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  type = map(string)
}

variable "public_key" {
  description = "Public key value to use for backend SSH"
  type = string
}

resource "random_id" "id" {
  byte_length = 4
}

locals {
  resource_group_name = "boundary-backend-${random_id.id.hex}"

  backend_net_nsg    = "backend-net-${random_id.id.hex}"

  backend_nic_nsg    = "backend-nic-${random_id.id.hex}"

  backend_asg    = "backend-asg-${random_id.id.hex}"

  backend_vm    = "backend-${random_id.id.hex}"

}