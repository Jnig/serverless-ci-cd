resource "aws_secretsmanager_secret" "ssh_key" {
  name                = "git-mirror-${var.name}"

  rotation_rules {
    automatically_after_days = 0
  }
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.ssh_key.id
  secret_string = var.ssh_key
}