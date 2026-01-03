#############################
# Redis (Elasticache)
#############################

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = "my-redis-cluster"
  description           = "Redis primary and replica in private subnets"
  node_type             = "cache.t3.micro"
  num_node_groups       = 1
  replicas_per_node_group = 1
  automatic_failover_enabled = true
  engine                = "redis"
  engine_version        = "7.0"
  parameter_group_name  = "default.redis7"
  port                  = 6379
  subnet_group_name     = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids    = [aws_security_group.eks_cluster.id]

  tags = {
    Name = "redis-cluster"
  }
}
