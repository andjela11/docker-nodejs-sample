module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name}-vpc"
  cidr = var.vpc_cidr_block

  azs             = var.azs
  private_subnets = var.private_subnet_cidr
  public_subnets  = var.public_subnet_cidr
  database_subnets = var.db_subnet_cidr

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  create_igw = true

  tags = {
    Terraform = "true"
    Owner = var.Owner
  }
}