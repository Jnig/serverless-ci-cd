provider "aws" {
  version = "~> 2.0"
  region = "eu-central-1"
}

module "mirror" {
  source = "../../modules/codepipeline"
}

