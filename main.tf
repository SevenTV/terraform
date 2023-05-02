terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "7tv"

    workspaces {
      prefix = "7tv-infra-"
    }
  }
}

locals {
  workspace = trimprefix(terraform.workspace, "7tv-infra-")
}

module "cluster" {
  source = "./cluster"

  control_plane_high_availability = local.workspace == "prod"
  label                           = "7tv-${local.workspace}"
  pools = local.workspace == "prod" ? [{
    // 6 nodes, 4 vCPUs, 8GB RAM
    count = 6
    type  = "g6-standard-4"
    }, {
    // 6 nodes, 6 vCPUs, 16GB RAM
    count = 6
    type  = "g6-standard-6"
    }, {
    // 3 nodes (high memory) 2 vCPUs 24GB RAM
    count = 3
    type  = "g7-highmem-1"
    }, {
    // 6 nodes 16 vCPUs 32GB RAM
    count = 6
    type  = "g6-standard-8"
  }] : [{
    // 2 nodes, 4 vCPUs, 8GB RAM
    count = 2
    type  = "g6-standard-4"
    }, {
    // 2 nodes, 6 vCPUs, 16GB RAM
    count = 2
    type  = "g6-standard-6"
    }, {
    // 1 nodes (high memory) 2 vCPUs 24GB RAM
    count = 1
    type  = "g7-highmem-1"
    }, {
    // 2 nodes 16 vCPUs 32GB RAM
    count = 2
    type  = "g6-standard-8"
  }]
}

module "monitoring" {
  source            = "./monitoring"
  loki_bucket_name  = "7tv-${local.workspace}-loki"
  mimir_bucket_name = "7tv-${local.workspace}-mimir"
  s3_endpoint       = "us-east-1.linodeobjects.com"
  s3_region         = "us-east-1"
  grafana_domain    = "grafana.${local.workspace}.disembark.dev"

  depends_on = [
    module.cluster,
  ]
}

module "cert_manager" {
  source = "./cert_manager"

  cloudflare_api_token = var.cloudflare_api_token

  depends_on = [
    module.cluster,
    module.monitoring,
  ]
}


module "database" {
  source = "./database"

  mongo_replica_count = local.workspace == "prod" ? 6 : 1
  redis_replica_count = local.workspace == "prod" ? 3 : 1
  rmq_replica_count   =  local.workspace == "prod" ? 3 : 1

  depends_on = [
    module.cluster,
    module.monitoring,
    module.cert_manager,
  ]
}

module "nginx_ingress" {
  source = "./nginx_ingress"

  min_replicas = local.workspace == "prod" ? 10 : 1
  max_replicas = local.workspace == "prod" ? 100 : 1

  depends_on = [
    module.cluster,
    module.monitoring,
  ]
}

module "external_dns" {
  source = "./external_dns"

  cloudflare_api_token = var.cloudflare_api_token

  depends_on = [
    module.cluster,
    module.monitoring,
  ]
}
