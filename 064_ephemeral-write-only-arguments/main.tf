terraform {
  cloud {
    organization = "examprotraining"
    workspaces {
      name = "lab-ephemeral-write-only"
    }
  }

  required_version = ">= 1.11.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# SECURE: ephemeral values are generated at runtime and NOT stored in state
ephemeral "random_password" "db_password" {
  length  = 20
  special = true
}

# Write-only argument example
resource "terraform_data" "secret_sink" {

  # write-only input
  input_wo = ephemeral.random_password.db_password.result

  # version lets us rotate intentionally
  input_wo_version = 1
}

output "resource_id" {
  value = terraform_data.secret_sink.id
}