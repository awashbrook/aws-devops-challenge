terraform {
  required_version = ">= 0.13.1"
  backend "remote" {
      organization = "andywash-devops"
      workspaces {
        name = "aws-devops-challenge"
      }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63"
    }
  }
}
