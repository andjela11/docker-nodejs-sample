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

data "kubernetes_ingress_v1" "chart" {
  metadata {
    name = "todo-app-ingress"
    namespace = "vegait-training"
  }
}

data "aws_lb" "alb" {
  depends_on = [helm_release.todoapp]
  name = local.lb_name[0]
}

locals {
  dns_part_name = split(".", data.kubernetes_ingress_v1.chart.status.0.load_balancer.0.ingress.0.hostname)[0]
  lb_name = regex("^(.*?)-[0-9]+$", local.dns_part_name)
}


