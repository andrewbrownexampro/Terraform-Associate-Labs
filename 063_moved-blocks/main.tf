terraform {
  cloud {
    organization = "examprotraining"
    workspaces {
      name = "lab-moved-blocks"
    }
  }

  required_version = ">= 1.1.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

moved {
  from = random_pet.rg
  to   = random_pet.resource_group_name
}

# Rename the resource for clarity
resource "random_pet" "resource_group_name" {
  length = 2
}

output "pet_name" {
  value = random_pet.resource_group_name.id
}