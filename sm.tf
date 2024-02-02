resource "random_password" "password_rds" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "saa_sm" {
  name = "saa_password_manager"
}

resource "aws_secretsmanager_secret_version" "saa_sm_version" {
  secret_id     = aws_secretsmanager_secret.saa_sm.id
  secret_string = random_password.password_rds.result
}