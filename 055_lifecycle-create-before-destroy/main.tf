terraform {
  cloud {
    organization = "examprotraining"
    workspaces {
      name = "lab-create-before-destroy"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-cbd-demo"
  location = "East US"
}

resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_public_ip" "pip" {
  name                = "pip-cbd-${random_string.suffix.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku = "Standard" 

  lifecycle {
    create_before_destroy = true
  }
}

output "pip_name" {
  value = azurerm_public_ip.pip.name
}
