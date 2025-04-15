resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.environment}-redis-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.environment}-products-cache"
  engine               = "redis"
  node_type            = var.redis_node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.x"
  port                 = 6379
  security_group_ids   = [aws_security_group.redis.id]
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
}

resource "aws_security_group" "redis" {
  name        = "${var.environment}-redis-sg"
  description = "Security group for Redis cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = var.security_group_ids
  }

  tags = {
    Name = "${var.environment}-redis-sg"
  }
}
