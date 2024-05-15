variable "vpc_cidr_block" {
  type = string
  default = "172.17.0.0/16"
}

variable "private_subnet_cidr" {
  type = list(string)
  description = "Private Subnet CIDR values"
  default = [ "172.17.0.0/18", "172.17.64.0/18", "172.17.128.0/18" ]
}

variable "public_subnet_cidr" {
  type = list(string)
  description = "Public Subnet CIDR values"
  default = [ "172.17.192.0/24", "172.17.193.0/24", "172.17.194.0/24" ]
}

variable "db_subnet_cidr" {
  type = list(string)
  description = "DB Subnet CIDR values"
  default = [ "172.17.195.0/24", "172.17.196.0/24", "172.17.197.0/24" ]
}

variable "Owner" {
    type = string
    default = "Andjela Jovanovic"
}

variable "name" {
  type = string
  default = "to-do-app"
}

variable "azs" {
  type = list(string)
  default = [ "eu-central-1a", "eu-central-1b", "eu-central-1c" ]
}