provider "aws" {
  version = "~> 2.0"
  region  = "eu-central-1"
}



module "mirror" {
  source = "../../modules/codepipeline"

  codecommit_repo_name   = "git-mirror-test-repo"
  codecommit_repo_branch = "master"
  stages = [{
    name = "foo"
    actions = [{
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "test"
      }
    }]
    },
    {
      name = "approval"
      actions = [{
        name             = "Build"
        category         = "Build"
        owner            = "AWS"
        provider         = "CodeBuild"
        input_artifacts  = ["source_output"]
        output_artifacts = ["build_output"]
        version          = "1"

        configuration = {
          ProjectName = "test"
        }
      }]
    }
  ]

}

