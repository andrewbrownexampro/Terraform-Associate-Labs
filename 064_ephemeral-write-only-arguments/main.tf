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

# INSECURE BASELINE: random_password is stored in state
resource "random_password" "db_password" {
  length  = 20
  special = true
}

# We'll pretend this is "sending a secret somewhere"
# (output is marked sensitive, but the value is still in state)
output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}