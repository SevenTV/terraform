resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "grafana"
  version          = var.grafana_chart_version
  namespace        = var.grafana_namespace
  create_namespace = true

  depends_on = [
    helm_release.prometheus,
  ]

  set {
    name  = "grafana.metrics.enabled"
    value = "true"
  }

  set {
    name  = "grafana.metrics.serviceMonitor.enabled"
    value = "true"
  }

  set {
    name  = "grafana.metrics.serviceMonitor.namespace"
    value = var.prometheus_namespace
  }

  set {
    name  = "grafana.metrics.serviceMonitor.interval"
    value = var.prometheus_scrape_interval
  }

  set {
    name  = "grafana.volumePermissions.enabled"
    value = "true"
  }

  set {
    name  = "grafana.updateStrategy.type"
    value = "Recreate"
  }

  set {
    name  = "grafana.updateStrategy.rollingUpdate"
    value = "null"
  }
}
