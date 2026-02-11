terraform {
  cloud {
    organization = "examprotraining"
    workspaces {
      name = "lab-variable-validation"
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

# Allowed values validation 
variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "prd" # intentionally wrong to demonstrate validation failure

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "environment must be one of: dev, stage, prod."
  }
}

# Format validation 
variable "resource_group_name" {
  description = "Name of the resource group (must start with rg-)"
  type        = string
  default     = "resource-group-demo" # intentionally wrong test

  validation {
    condition     = can(regex("^rg-[a-z0-9-]{3,20}$", var.resource_group_name))
    error_message = "resource_group_name must start with 'rg-' and use lowercase letters, numbers, and hyphens (3-20 chars after rg-)."
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "East US"
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
