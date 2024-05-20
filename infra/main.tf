terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
  profile = var.profile
}

module "vpc" {
  source = "./modules/vpc"
}

module "iam" {
  source = "./modules/iam"
  aws_region = var.region
  owner_tag = var.owner
  app_name = var.name
}

