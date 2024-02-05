terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.25"
      access_key = var.access_key
      secret_key = var.secret_access_key
    }
}