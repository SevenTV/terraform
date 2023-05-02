variable "namespace" {
  description = "The namespace to deploy the Nginx Ingress Controller to."
  default     = "nginx-ingress"
}

variable "chart_version" {
  description = "The version of the Nginx Ingress Controller Helm chart to use."
  default     = "9.6.1"
}

variable "prometheus_namespace" {
  description = "The namespace to where Prometheus is deployed to."
  default     = "prometheus"
}

variable "prometheus_scrape_interval" {
  description = "The interval at which Prometheus should scrape metrics."
  default     = "10s"
}

variable "min_replicas" {
  description = "The minimum number of replicas to run."
  default     = 10
}

variable "max_replicas" {
  description = "The maximum number of replicas to run."
  default     = 100
}
