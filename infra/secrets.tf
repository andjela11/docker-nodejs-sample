module "secrets_manager" {
  source = "terraform-aws-modules/secrets-manager/aws"
  description = "secrets for db"
  name = "credentials-postgres-andjela"

  ignore_secret_changes = true
  secret_string = jsonencode({
    db-username = ""
    db-password = ""
    db-name   = ""
  })

  tags = {
    Owner = var.owner
  }
}


data "aws_secretsmanager_secret_version" "current" {
  secret_id = module.secrets_manager.secret_id
}