output "kubeconfig" {
  value       = module.cluster.kubeconfig
  description = "The kubeconfig for the cluster."
  sensitive   = true
}

output "redis_password" {
  value       = module.database.redis_password
  description = "The password for the Redis server."
  sensitive   = true
}

output "redis_host" {
  value       = module.database.redis_host
  description = "The host for the Redis sentinel."
}

output "mongo_host" {
  value       = module.database.mongo_host
  description = "The host for the MongoDB Server."
}

output "mongo_password" {
  value       = module.database.mongo_password
  description = "The host for the MongoDB Server."
  sensitive = true
}

output "rmq_password" {
  value       = module.database.rmq_password
  description = "The password for the RabbitMQ Server."
  sensitive = true
}

output "rmq_host" {
  value       = module.database.rmq_host
  description = "The host for the RabbitMQ Server."
}
