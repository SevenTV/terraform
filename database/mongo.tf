resource "kubernetes_namespace" "mongo" {
  metadata {
    name = var.mongo_namespace
  }
}

resource "random_password" "mongo" {
  length  = 32
  special = false
}

resource "random_password" "mongo_replica_key" {
  length  = 32
  special = false
}

resource "helm_release" "mongo" {
  name       = "mongo"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"
  version    = var.mongo_chart_version
  namespace  = var.mongo_namespace

  depends_on = [
    kubernetes_namespace.mongo,
  ]

  set {
    name  = "auth.rootPassword"
    value = random_password.mongo.result
  }

  set {
    name  = "replicaCount"
    value = var.mongo_replica_count
  }

  set {
    name = "auth.replicaSetKey"
    value = random_password.mongo_replica_key.result
  }

  set {
    name  = "architecture"
    value = "replicaset"
  }

  set {
    name  = "resources.requests.cpu"
    value = var.mongo_cpu_request
  }

  set {
    name  = "resources.requests.memory"
    value = var.mongo_memory_request
  }


  set {
    name  = "persistence.size"
    value = var.mongo_disk_size
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
}
