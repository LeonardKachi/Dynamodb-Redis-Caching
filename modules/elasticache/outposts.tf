output "redis_endpoint" {
  description = "Redis primary endpoint"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "redis_sg_id" {
  description = "Redis security group ID"
  value       = aws_security_group.redis.id
}
