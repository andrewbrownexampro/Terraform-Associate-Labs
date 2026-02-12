terraform {
  cloud {
    organization = "examprotraining"
    workspaces {
      name = "lab-check-blocks"
    }
  }

  required_version = ">= 1.5.0"

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

resource "azurerm_resource_group" "rg" {
  name     = "rg-check-tags-demo"
  location = "East US"

  tags = {
    owner = "terraform"
    environment = "prod" # This tag is required by the check block below
  }
}

# CHECK BLOCK (runs after plan/apply)
# We require an "environment" tag to exist on the deployed RG
check "rg_requires_environment_tag" {
  assert {
    condition     = contains(keys(azurerm_resource_group.rg.tags), "environment")
    error_message = "Check failed: Resource group must include an 'environment' tag (example: environment = \"prod\")."
  }
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "resource_group_tags" {
  value = azurerm_resource_group.rg.tags
}