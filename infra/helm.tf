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
    name = "defaultTargetType"
    value = "ip"
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
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string)), "db-username", "what?")
   }

   set {
    name = "auth.password"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string)), "db-password", "what?")
   }
  
   set {
    name = "auth.database"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string)), "db-name", "what?")
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

resource "helm_release" "todoapp" {
  name       = "todo-app"
  chart      = "${var.name}-repo"
  namespace  = "vegait-training"
  repository = join("", ["oci://", module.ecr.repository_registry_id, ".dkr.ecr.", var.region, ".amazonaws.com"])
  version = "0.1.2"

  set {
    name = "app.name"
    value = "todo-app"
  }
    set {
    name = "app.label"
    value = "todo-app"
  }
  set {
    name = "app.port"
    value = 3000
  }
  set {
    name = "app.replicas"
    value = 1
  }
  set {
    name = "container.image"
    value = module.ecr.repository_url
  }
  set {
    name = "container.tag"
    value = "docker-v1.2.7"
  }
  set {
    name = "service.port"
    value = 443
  }
  set {
    name = "service.targetPort"
    value = 3000
  }
  set {
    name = "service.protocol"
    value = "TCP"
  }
  set {
    name = "ingress.host"
    value = "andjela-jovanovic.lambda.devops.sitesstage.com"
  }
  set {
    name = "ingress.class"
    value = "alb"
  }
  set {
    name = "secret.dbuser"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string)), "db-username", "what?")
  }
  set {
    name = "secret.dbpassword"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string)), "db-password", "what?")
  }
  set {
    name = "secret.dbname"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string)), "db-name", "what?")
  }
  set {
    name = "config.host"
    value = "mypostgresql-hl"
  }
}