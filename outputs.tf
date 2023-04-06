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
