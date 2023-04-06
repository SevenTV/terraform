resource "kubernetes_namespace" "redis" {
  metadata {
    name = var.redis_namespace
  }
}

resource "random_password" "redis" {
  length  = 32
  special = false
}

resource "helm_release" "redis" {
  name       = "redis"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  version    = var.redis_chart_version
  namespace  = var.redis_namespace

  depends_on = [
    kubernetes_namespace.redis,
  ]

  set {
    name  = "auth.password"
    value = random_password.redis.result
  }

  set {
    name  = "sentinel.enabled"
    value = "true"
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
    name  = "replica.replicaCount"
    value = var.redis_replica_count
  }

  set {
    name  = "replica.resources.requests.cpu"
    value = var.redis_replica_cpu
  }

  set {
    name  = "replica.resources.requests.memory"
    value = var.redis_replica_memory
  }

  set {
    name  = "replica.resources.limits.cpu"
    value = var.redis_replica_cpu
  }

  set {
    name  = "replica.resources.limits.memory"
    value = var.redis_replica_memory
  }
}
