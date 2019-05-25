module "build-docker-image" {
  source = "../../modules/codebuild"

  name         = "build-docker-image"
  artifacts    = "CODEPIPELINE"
  docker_image = "ubuntu"

  buildspec = <<EOF
version: 0.2         
phases:
  build:
    commands:
      - find ./
artifacts:
  files:
    - '**/*'
  name: build_output 
EOF
}

module "deploy-to-staging" {
  source = "../../modules/codebuild"

  name = "deploy-to-staging"
  artifacts = "CODEPIPELINE"
  docker_image = "ubuntu"
  buildspec = <<EOF
version: 0.2         
phases:
  build:
    commands:
      - find ./
EOF
}

