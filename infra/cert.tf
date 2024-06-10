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

resource "aws_route53_record" "to-do-app" {
  zone_id = data.aws_route53_zone.lambda_hosted_zone.zone_id
  name   = "andjela-jovanovic.${var.lambda_domain_name}"
  type    = "A"

   alias {
    name = data.aws_lb.alb.dns_name
    zone_id = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}


data "aws_lb" "alb" {
  depends_on = [helm_release.todoapp]
  name = "k8s-vegaittr-todoappi-1ddf919bf1"
}