resource "kubernetes_namespace" "rmq" {
  metadata {
    name = var.rmq_namespace
  }
}

resource "random_password" "rmq" {
  length  = 32
  special = false
}

resource "helm_release" "rmq" {
  name       = "rmq"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "rabbitmq"
  version    = var.rmq_chart_version
  namespace  = var.rmq_namespace

  depends_on = [
    kubernetes_namespace.rmq,
  ]

  set {
    name  = "auth.password"
    value = random_password.rmq.result
  }

  set {
    name  = "metrics.enabled"
    value = "true"
  }

  set {
    name  = "metrics.serviceMonitor.enabled"
    value = "true"
  }

  set {
    name  = "metrics.serviceMonitor.namespace"
    value = var.prometheus_namespace
  }

  set {
    name  = "metrics.serviceMonitor.interval"
    value = var.prometheus_scrape_interval
  }

  set {
    name  = "volumePermissions.enabled"
    value = "true"
  }

  set {
    name  = "replicaCount"
    value = var.rmq_replica_count
  }

  set {
    name  = "resources.requests.cpu"
    value = var.rmq_replica_cpu
  }

  set {
    name  = "resources.requests.memory"
    value = var.rmq_replica_memory
  }

  set {
    name  = "resources.limits.cpu"
    value = var.rmq_replica_cpu
  }

  set {
    name  = "resources.limits.memory"
    value = var.rmq_replica_memory
  }
}
