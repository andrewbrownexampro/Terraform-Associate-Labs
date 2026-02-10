terraform {
  cloud {
    organization = "examprotraining"
    workspaces {
      name = "lab-create-before-destroy"
    }
  }

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

resource "random_pet" "example" {
  length = 3

  lifecycle {
    create_before_destroy = true
  }
}

output "pet_name" {
  value = random_pet.example.id
}
