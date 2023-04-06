output "redis_password" {
  value       = random_password.redis.result
  description = "The password for the Redis server."
  sensitive   = true
}

output "redis_host" {
  value       = "redis.${var.redis_namespace}.svc.cluster.local:26379"
  description = "The host for the Redis sentinel."
}

