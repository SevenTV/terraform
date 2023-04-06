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
  pools = [{
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
    count = 7
    type  = "g6-standard-8"
  }]
}

module "monitoring" {
  source            = "./monitoring"
  loki_bucket_name  = "7tv-${local.workspace}-loki"
  mimir_bucket_name = "7tv-${local.workspace}-mimir"
  s3_endpoint       = "us-east-1.linodeobjects.com"
  s3_region         = "us-east-1"

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

  depends_on = [
    module.cluster,
    module.monitoring,
    module.cert_manager,
  ]
}

module "nginx_ingress" {
  source = "./nginx_ingress"

  depends_on = [
    module.cluster,
  ]
}

module "external_dns" {
  source = "./external_dns"

  cloudflare_api_token = var.cloudflare_api_token

  depends_on = [
    module.cluster,
  ]
}
