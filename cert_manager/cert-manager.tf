resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "cert-manager"
  version          = var.cert_manager_chart_version
  namespace        = var.namespace
  create_namespace = true

  set {
    name  = "installCRDs"
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
}

resource "kubernetes_secret" "cloudflare_cluster_issuer_api_token" {
  metadata {
    name      = "cloudflare-cluster-issuer-api-token"
    namespace = var.namespace
  }

  data = {
    api-token = var.cloudflare_api_token
  }

  depends_on = [
    helm_release.cert_manager,
  ]

  type = "Opaque"
}

resource "kubectl_manifest" "cloudflare_cluster_issuer" {
  depends_on = [
    helm_release.cert_manager,
  ]

  yaml_body = yamlencode({
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "cloudflare"
    }
    spec = {
      acme = {
        email  = var.acme_email
        server = "https://acme-v02.api.letsencrypt.org/directory"
        privateKeySecretRef = {
          name = "cloudflare-cluser-issuer-account-key"
        }
        solvers = [{
          dns01 = {
            cloudflare = {
              apiTokenSecretRef = {
                name = kubernetes_secret.cloudflare_cluster_issuer_api_token.metadata[0].name
                key  = "api-token"
              }
            }
          }
        }]
      }
    }
  })
}
