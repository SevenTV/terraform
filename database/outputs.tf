output "redis_password" {
  value       = random_password.redis.result
  description = "The password for the Redis server."
  sensitive   = true
}

output "redis_host" {
  value       = "redis.${var.redis_namespace}.svc.cluster.local:26379"
  description = "The host for the Redis sentinel."
}

output "mongo_password" {
  value       = random_password.mongo.result
  description = "The password for the Mongo server."
  sensitive   = true
}

output "mongo_host" {
  value       = "mongo-mongodb-headless.${var.mongo_namespace}.svc.cluster.local:27017"
  description = "The host for the Redis sentinel."
}

output "rmq_password" {
  value       = random_password.rmq.result
  description = "The password for the RabbitMQ server."
  sensitive   = true
}

output "rmq_host" {
  value       = "rmq-rabbitmq.${var.rmq_namespace}.svc.cluster.local:5672"
  description = "The host for the RabbitMQ server."
}
