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

# Step A: Start with a simple resource address.
resource "random_pet" "rg" {
  length = 2
}

output "pet_name" {
  value = random_pet.rg.id
}