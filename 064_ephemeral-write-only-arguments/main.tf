terraform {
  cloud {
    organization = "examprotraining"
    workspaces {
      name = "lab-ephemeral-write-only"
    }
  }

  required_version = ">= 1.11.0"

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

data "azurerm_client_config" "current" {}

# 1) Create RG + Key Vault 
resource "azurerm_resource_group" "rg" {
  name     = "rg-ephemeral-writeonly-demo"
  location = "East US"
}

resource "azurerm_key_vault" "kv" {
  name                = "kv${substr(replace(uuid(), "-", ""), 0, 18)}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name  = "standard"
}

# Give the current identity (your Service Principal) permission to set/get secrets
resource "azurerm_key_vault_access_policy" "sp" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = ["Get", "Set", "List", "Delete"]
}

# 2) Ephemeral value generation (never stored in state)
ephemeral "random_password" "kv_secret" {
  length  = 24
  special = true
}

# 3) Write-only argument stores secret in Key Vault without storing it in state/plan
resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"
  key_vault_id = azurerm_key_vault.kv.id

  # write-only value (not stored in state/plan)
  value_wo         = ephemeral.random_password.kv_secret.result
  value_wo_version = 1
}

output "key_vault_name" {
  value = azurerm_key_vault.kv.name
}

output "secret_name" {
  value = azurerm_key_vault_secret.db_password.name
}