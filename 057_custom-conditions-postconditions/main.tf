terraform {
  cloud {
    organization = "examprotraining"
    workspaces {
      name = "lab-postconditions"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "rg_location" {
  description = "Azure region for the resource group"
  type        = string
  default     = "East US" # Changed to East US to satisfy the postcondition after initial failure
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-postcondition-demo"
  location = var.rg_location

  lifecycle {
    postcondition {
      condition     = self.location == "eastus"
      error_message = "Postcondition failed: resource group must be in East US (eastus)."
    }
  }
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  value = azurerm_resource_group.rg.location
}