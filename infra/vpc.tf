module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = module.vpc.vpc_cidr_block
  networks = [
    {
      name     = "subnet-private-1A"
      new_bits = 2
    },
    {
      name     = "subnet-private-1B"
      new_bits = 2
    },
     {
      name     = "subnet-private-1C"
      new_bits = 2
    },
     {
      name     = "subnet-public-1A"
      new_bits = 8
    },
    {
      name     = "subnet-public-1B"
      new_bits = 8
    },
    {
      name     = "subnet-public-1C"
      new_bits = 8
    },
    {
      name     = "subnet-db-1A"
      new_bits = 8
    },
      {
      name     = "subnet-db-1B"
      new_bits = 8
    },
      {
      name     = "subnet-db-1C"
      new_bits = 8
    },
  ]
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name}-vpc"
  cidr = var.vpc_cidr_block

  azs = data.aws_availability_zones.available.names
  private_subnets = [lookup(module.subnet_addrs.network_cidr_blocks, "subnet-private-1A", "default"),lookup(module.subnet_addrs.network_cidr_blocks, "subnet-private-1B", "default"), lookup(module.subnet_addrs.network_cidr_blocks, "subnet-private-1C", "default")]
  public_subnets = [lookup(module.subnet_addrs.network_cidr_blocks, "subnet-public-1A", "default"),lookup(module.subnet_addrs.network_cidr_blocks, "subnet-public-1B", "default"), lookup(module.subnet_addrs.network_cidr_blocks, "subnet-public-1C", "default")]
  database_subnets = [lookup(module.subnet_addrs.network_cidr_blocks, "subnet-db-1A", "default"),lookup(module.subnet_addrs.network_cidr_blocks, "subnet-db-1B", "default"), lookup(module.subnet_addrs.network_cidr_blocks, "subnet-db-1C", "default")]

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  create_igw = true

  tags = {
    Terraform = "true"
    Owner = var.owner
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}