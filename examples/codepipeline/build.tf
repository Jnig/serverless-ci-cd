module "codebuild" {
  source = "../../modules/codebuild"

  name         = "build-docker-image"
  artifacts    = "CODEPIPELINE"
  docker_image = "ubuntu"
}
