terraform {
  cloud {
    organization = "examprotraining"
    workspaces {
      name = "lab-preconditions"
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

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev" # changed to dev to satisfy the precondition
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-precondition-demo"
  location = "East US"

  lifecycle {
    precondition {
      condition     = var.environment == "dev"
      error_message = "Environment must be 'dev' to create this resource group."
    }
  }
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
