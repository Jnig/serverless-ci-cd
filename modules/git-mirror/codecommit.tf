resource "aws_codecommit_repository" "repo" {
  repository_name = "git-mirror-${var.name}"
  description     = "git-mirror-${var.name}"
}