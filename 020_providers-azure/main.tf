terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.77.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "terraform_azure_providers" {
  name     = "terraform_azure_providers"
  location = "East US"
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.terraform_azure_providers.name

  subnet_prefixes = ["10.0.1.0/24"]
  subnet_names    = ["subnet1"]

  use_for_each = true

  depends_on = [azurerm_resource_group.terraform_azure_providers]
}

module "linuxservers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.terraform_azure_providers.name
  vm_os_simple        = "UbuntuServer"
  public_ip_dns       = ["linsimplevmips"] // must be globally unique in region
  vnet_subnet_id      = module.network.vnet_subnets[0]
  vm_size             = "Standard_B1ls"

  depends_on = [azurerm_resource_group.terraform_azure_providers]
}

output "linux_vm_public_name" {
  value = module.linuxservers.public_ip_dns_name
}