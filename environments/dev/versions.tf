terraform {
  required_providers {
    aws = {
      version = "~> 2.0"
      source  = "hashicorp/aws"
    }
    random = {
      version = "~> 2.3.0"
      source  = "hashicorp/random"
    }
    template = {
      version = "~> 2.1.2"
      source  = "hashicorp/template"
    }
  }
  required_version = ">= 0.13"
}
