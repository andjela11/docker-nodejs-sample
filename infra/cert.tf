module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = "andjela-jovanovic.${var.lambda_domain_name}"
  zone_id = data.aws_route53_zone.lambda_hosted_zone.zone_id

  validation_method = "DNS"

  tags = {
    Owner = var.owner
  }
}

data "aws_route53_zone" "lambda_hosted_zone" {
  name         = var.lambda_domain_name
  private_zone = false
}