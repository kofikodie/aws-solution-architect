resource "aws_elasticache_cluster" "redis_cache" {
  cluster_id               = "redis-cluster"
  engine                   = "redis"
  engine_version           = "7.1"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
  parameter_group_name     = "default.redis7"
  port                     = 6379
  subnet_group_name        = aws_elasticache_subnet_group.redis_cache_subnet_group.name
  security_group_ids       = [aws_security_group.redis_cache_sg.id]
  snapshot_retention_limit = 0

}

resource "aws_elasticache_subnet_group" "redis_cache_subnet_group" {
  name       = "redis-cache-subnet-group"
  subnet_ids = [aws_subnet.this_public[0].id, aws_subnet.this_public[1].id]
}


resource "aws_security_group" "redis_cache_sg" {
  name        = "redis-cache-sg"
  description = "Security group for Redis cache"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
