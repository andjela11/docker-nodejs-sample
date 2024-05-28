resource "helm_release" "alb_controler" {
  name = "load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version = "1.7.2"
  namespace = "k8s-alb-ns"
  create_namespace = true
  chart = "aws-load-balancer-controller"

  set {
    name = "region"
    value = var.region
  }
  set {
    name = "clusterName"
    value = module.eks.cluster_name
  }
  set {
    name = "vpcId"
    value = module.vpc.vpc_id
  }
  set {
    name = "replicaCount"
    value = 1
  }
  set {
    name = "serviceAccount.create"
    value = true
  }
  set {
    name = "serviceAccount.name"
    value = "sa-alb-contr"
  }
  set {
    name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_eks_role.iam_role_arn
  }
}

resource "helm_release" "postgresql" {
  name       = "mypostgresql"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  namespace  = "vegait-training"
  create_namespace = true

  set {
    name = "auth.username"
    value = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["db-username"]
   }

   set {
    name = "auth.password"
    value = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["db-password"]
   }
  
   set {
    name = "auth.database"
    value = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["db-name"]
   }
   set {
    name = "primary.persistence.volumeName"
    value = "pvc-postgre-todoapp"
   }
   set {
    name = "primary.persistence.size"
    value = "8Gi"
   }
   set {
     name = "primary.persistence.storageClass"
     value = kubernetes_storage_class.storage_class.metadata[0].name
   }
   set {
    name  = "serviceAccount.create"
    value = false
  }
}