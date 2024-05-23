variable "profile" {
  description = "AWS profile"
  type = string
  default = "Vega-AndjelaJ"
}

variable "github_profile" {
  description = "Name for GitHub profile"
  type = string
  default = "andjela11"
}

variable "github_repo" {
  description = "Name for GitHub repo"
  type = map(string)
  default = {
    "todo-app-repo" = "docker-nodejs-sample"
  }
}

variable "region" {
  description = "AWS region"
  type = string
  default = "eu-central-1"
}

variable "owner" {
    type = string
    default = "Andjela Jovanovic"
}

variable "name" {
  type = string
  default = "to-do-app"
}

variable "vpc_cidr_block" {
  type = string
  default = "172.17.0.0/16"
}

variable "lambda_domain_name" {
  type = string
  default = "lambda.devops.sitesstage.com"
}