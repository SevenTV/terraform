resource "kubernetes_namespace" "mongo" {
  metadata {
    name = var.mongo_namespace
  }
}

resource "random_password" "mongo" {
  length  = 32
  special = false
}

resource "helm_release" "mongo" {
  name       = "mongo"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb-sharded"
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
    name  = "shards"
    value = var.mongo_shard_count
  }

  set {
    name  = "common.useHostnames"
    value = "true"
  }

  set {
    name  = "mongos.replicaCount"
    value = "3"
  }

  set {
    name  = "shardsvr.dataNode.replicaCount"
    value = var.mongo_replica_count
  }

  set {
    name  = "shardsvr.dataNode.resources.requests.cpu"
    value = var.mongo_cpu_request
  }

  set {
    name  = "shardsvr.dataNode.resources.requests.memory"
    value = var.mongo_memory_request
  }


  set {
    name  = "shardsvr.persistence.size"
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
