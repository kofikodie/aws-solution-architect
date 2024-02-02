
//data "aws_secretsmanager_secret" "saa_sm" {
//  name = "saa_password_manager"
//}
//
//data "aws_secretsmanager_secret_version" "saa_sm_version" {
//  secret_id = data.aws_secretsmanager_secret.saa_sm.id
//}

resource "aws_db_instance" "tfer--database-1" {
  allocated_storage                     = "20"
  auto_minor_version_upgrade            = "true"
  availability_zone                     = "eu-west-1a"
  backup_retention_period               = "7"
  backup_target                         = "region"
  backup_window                         = "02:21-02:51"
  ca_cert_identifier                    = "rds-ca-rsa2048-g1"
  copy_tags_to_snapshot                 = "true"
  customer_owned_ip_enabled             = "false"
  db_name                               = "mydb"
  deletion_protection                   = "true"
  engine                                = "mysql"
  engine_version                        = "8.0.35"
  iam_database_authentication_enabled   = "false"
  identifier                            = "database-1"
  instance_class                        = "db.t2.micro"
  iops                                  = "0"
  license_model                         = "general-public-license"
  maintenance_window                    = "mon:04:23-mon:04:53"
  max_allocated_storage                 = "1000"
  monitoring_interval                   = "60"
  multi_az                              = "false"
  network_type                          = "IPV4"
  option_group_name                     = "default:mysql-8-0"
  parameter_group_name                  = "default.mysql8.0"
  performance_insights_enabled          = "false"
  performance_insights_retention_period = "0"
  port                                  = "3306"
  publicly_accessible                   = "true"
  storage_encrypted                     = "false"
  storage_throughput                    = "0"
  storage_type                          = "gp2"
  username                              = "admin"
  password                              = "admin123"//data.aws_secretsmanager_secret_version.saa_sm_version.secret_string

}
