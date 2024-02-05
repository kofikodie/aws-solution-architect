data "aws_secretsmanager_secret" "saa_sm_rds" {
  name = "saa_pw_manager"
}

data "aws_secretsmanager_secret_version" "saa_sm_version" {
  secret_id = data.aws_secretsmanager_secret.saa_sm_rds.id
}

resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "aurora-subnet-group"
  subnet_ids = [aws_subnet.sub_a.id, aws_subnet.sub_b.id]
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "my-aurora-cluster"
  engine                  = "aurora-mysql"
  engine_mode             = "provisioned"
  master_username         = "admin"
  master_password         = data.aws_secretsmanager_secret_version.saa_sm_version.secret_string
  database_name           = "mydb"
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
  availability_zones = [
    "eu-west-1a",
    "eu-west-1b",
  ]
  db_subnet_group_name = aws_db_subnet_group.aurora_subnet_group.name
  skip_final_snapshot  = true
  deletion_protection  = false

  serverlessv2_scaling_configuration {
    max_capacity = 2
    min_capacity = 1
  }
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = "db.t3.medium"
  engine             = aws_rds_cluster.aurora_cluster.engine
  engine_version     = "8.0.mysql_aurora.3.04.1"
  identifier         = "my-aurora-instance"
}
