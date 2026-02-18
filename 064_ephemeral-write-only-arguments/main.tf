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

# Write-only argument example: Only a fingerprint is stored in state — not the secret.
resource "random_id" "password_fingerprint" {
  byte_length = 8

  # Write-only input (pretend this is a secret being passed to a real system)
  keepers_wo = {
    secret = ephemeral.random_password.db_password.result
  }

  # Version bump lets you rotate the secret intentionally
  keepers_wo_version = 1
}

output "password_fingerprint" {
  value = random_id.password_fingerprint.hex
}