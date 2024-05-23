module "iam_eks_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "irsa-lb-eks"

  attach_load_balancer_controller_policy=true
# namespace and service account will be changed once lb is created
  oidc_providers = {
    eks = {
      provider_arn               = "${module.eks.oidc_provider_arn}"
      namespace_service_accounts = ["default:service_account"]
    }
  }

  tags = {
    Owner = var.owner
  }
}