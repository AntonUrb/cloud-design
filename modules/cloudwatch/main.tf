resource "helm_release" "cloudwatch_agent" {
  name       = "cloudwatch-agent"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-cloudwatch-metrics"
  namespace  = "kube-system"
  version    = "0.0.3"

  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }

  set {
    name  = "cloudwatch.region"
    value = var.aws_region
  }

  set {
    name  = "createNamespace"
    value = "true"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "cloudwatch-agent"
  }

  depends_on = [aws_eks_cluster.eks]
}


resource "aws_cloudwatch_dashboard" "eks_dashboard" {
  dashboard_name = "eks-metrics-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        properties = {
          metrics = [
            [ "ContainerInsights", "cpu_usage_total", "ClusterName", eks_cluster_name ]
          ],
          view      = "timeSeries",
          stacked   = false,
          region    = var.aws_region,
          title     = "CPU Usage"
        }
      },
      {
        type = "metric",
        properties = {
          metrics = [
            [ "ContainerInsights", "memory_usage_total", "ClusterName", eks_cluster_name ]
          ],
          view      = "timeSeries",
          stacked   = false,
          region    = var.aws_region,
          title     = "Memory Usage"
        }
      }
    ]
  })
}

resource "helm_release" "fluentd" {
  name       = "fluentd"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluentd-cloudwatch"
  namespace  = "kube-system"
  version    = "0.12.0"

  set {
    name  = "cloudWatch.logs.region"
    value = var.aws_region
  }

  set {
    name  = "cloudWatch.logs.logGroupName"
    value = "/eks/logs"
  }

  depends_on = [aws_eks_cluster.eks]
}
