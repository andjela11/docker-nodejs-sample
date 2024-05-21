module "iam_github_oidc_provider" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"

  tags = {
    Owner = "Milan Stanisavljevic"
  }
}

module "iam_assumable_role_with_oidc" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"

  create_role = true

  role_name = "role-with-oidc-todo"

  oidc_subjects_with_wildcards = ["repo:${var.github_profile}/${var.github_repo.todo-app-repo}:*"]

  oidc_fully_qualified_audiences = [ "sts.amazonaws.com"]


  provider_url = module.iam_github_oidc_provider.url

  role_policy_arns = [
    module.iam_policy.arn
  ]

    tags = {
    Role = "role-with-oidc"
    Owner = var.owner
  }
}

module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "AllowGithubPushToECR"
  path        = "/"
  description = "Policy to allow github to push to ECR"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:CompleteLayerUpload",
              "ecr:GetAuthorizationToken",
              "ecr:UploadLayerPart",
              "ecr:InitiateLayerUpload",
              "ecr:BatchCheckLayerAvailability",
              "ecr:PutImage"
      ],
      "Effect": "Allow",
      "Resource": "${module.ecr.repository_arn}"
    }
  ]
}
EOF
}

