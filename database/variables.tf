variable "redis_namespace" {
  description = "The namespace to deploy Redis to."
  default     = "redis"
}

variable "redis_chart_version" {
  description = "The version of the Redis chart to use."
  default     = "17.10.1"
}

variable "redis_replica_count" {
  description = "The number of replicas to deploy."
  default     = 3
}

variable "redis_replica_cpu" {
  description = "The CPU to allocate to each replica."
  default     = "300m"
}

variable "redis_replica_memory" {
  description = "The memory to allocate to each replica."
  default     = "1Gi"
}

variable "mongo_namespace" {
  description = "The namespace to deploy MongoDB to."
  default     = "mongo"
}

variable "mongo_chart_version" {
  description = "The version of the MongoDB chart to use."
  default     = "13.10.2"
}

variable "mongo_replica_count" {
  description = "The number of replicas to deploy."
  default     = 6
}

variable "mongo_cpu_request" {
  description = "The CPU to allocate to each replica."
  default     = "6500m"
}

variable "mongo_memory_request" {
  description = "The memory to allocate to each replica."
  default     = "7.5Gi"
}

variable "mongo_disk_size" {
  description = "The size of the disk to allocate to each replica."
  default     = "100Gi"
}

variable "rmq_namespace" {
  description = "The namespace to deploy RabbitMQ to."
  default     = "rmq"
}

variable "rmq_chart_version" {
  description = "The version of the RabbitMQ chart to use."
  default     = "11.14.4"
}

variable "rmq_replica_count" {
  description = "The number of replicas to deploy."
  default     = 3
}

variable "rmq_replica_cpu" {
  description = "The CPU to allocate to each replica."
  default     = "500m"
}

variable "rmq_replica_memory" {
  description = "The memory to allocate to each replica."
  default     = "512Mi"
}

variable "prometheus_namespace" {
  description = "The namespace Prometheus is deployed to."
  default     = "prometheus"
}

variable "prometheus_scrape_interval" {
  description = "The interval at which Prometheus should scrape metrics."
  default     = "10s"
}
