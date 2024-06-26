module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "cluster-andjela"
  cluster_version = "1.29"

  cluster_endpoint_public_access  = true
  #public endpoint
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  #cluster private endpoint access
  cluster_endpoint_private_access = true
  

  vpc_id    =  module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
      addon_version = "v1.30.0-eksbuild.1"
      resolve_conflicts = "PRESERVE"
    }
  }

  access_entries = {
    github = {
      principal_arn=module.iam_assumable_role_with_oidc.iam_role_arn

      policy_associations = {
        github = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
          access_scope = {
            namespaces = ["vegait-training"]
            type = "namespace"
          }
        }
      }
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    node-group-andjela = {
     create_iam_role = true    
     iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
     }
      min_size     = 1
      max_size     = 10
      desired_size = 1

      ami_type = "BOTTLEROCKET_x86_64"

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
    }
  }
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true
  

  tags = {
    Terraform   = "true"
    Owner = var.owner
  }
}

resource "kubernetes_storage_class" "storage_class" {
  metadata {
    name = "storage-class-postgre"
  }
  depends_on = [ module.eks ]

  storage_provisioner = "ebs.csi.aws.com"
  volume_binding_mode = "WaitForFirstConsumer"
  allow_volume_expansion = true
  parameters = {
    "encrypted" = "true"
  }
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name =  module.eks.cluster_name
}