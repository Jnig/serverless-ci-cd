provider "aws" {
  version = "~> 2.0"
  region = "eu-central-1"
}

variable name {
  default = "test-repo"
}

variable git_repo {
  default = "git@github.com:Jnig/serverless-ci-cd.git"
}

module "mirror" {
  source = "../../modules/git-mirror"

  name = var.name
  ssh_key = "${file("~/.ssh/id_rsa")}"
  git_repo = var.git_repo
}

output webhook_url {
  value = module.mirror.webhook_url
}
