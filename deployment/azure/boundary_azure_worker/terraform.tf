terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>1.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "boundary" {
  name = local.resource_group_name
  location = var.location
}