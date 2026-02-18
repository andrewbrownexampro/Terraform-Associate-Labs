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
      version = "~> 3.5"
    }

    terraform = {
      source  = "hashicorp/terraform"
      version = ">= 1.0.0"
    }
  }
}

# Ephemeral Secret
ephemeral "random_password" "db_password" {
  length  = 20
  special = true
}
# Write-Only Sink Resource
resource "terraform_data" "secret_sink" {
  input_wo         = ephemeral.random_password.db_password.result
  input_wo_version = 1
}
# Safe Output
output "resource_id" {
  value = terraform_data.secret_sink.id
}
