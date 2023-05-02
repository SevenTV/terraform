resource "random_password" "grafana" {
  length  = 32
  special = true
}

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
    name  = "admin.password"
    value = random_password.grafana.result
  }

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

  set {
    name = "ingress.enabled"
    value = "true"
  }

  set {
    name = "ingress.hostname"
    value = var.grafana_domain
  }

  set {
    name = "ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "nginx"
  }

  set {
    name = "ingress.tls"
    value = "true"
  }

  set {
    name = "ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "cloudflare"
  }

  set {
    name = "ingress.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
    value = var.grafana_domain
  }

  set {
    name = "ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "nginx"
  }
}
