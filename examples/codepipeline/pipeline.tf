locals {
  source = {
    name = "Source"
    actions = [{
      run_order        = 1
      name             = "Source-git"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      input_artifacts  = []
      output_artifacts = ["source_output"]
      version          = "1"

      configuration = {
        RepositoryName = "git-mirror-test-repo"
        BranchName     = "dev"
      }
      },
      {
        run_order        = 1
        name             = "Source-s3"
        category         = "Build"
        owner            = "AWS"
        provider         = "CodeBuild"
        input_artifacts  = []
        output_artifacts = []
        version          = "1"

        configuration = {
          ProjectName = "deploy-to-staging"
        }
      }
    ]




  }

  build = {
    name = "Build-and-deploy-to-staging"
    actions = [{
      run_order        = 1
      name             = "build-docker-image"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "build-docker-image"
      }
      },
      {
        run_order        = 2
        name             = "deploy-to-staging"
        category         = "Build"
        owner            = "AWS"
        provider         = "CodeBuild"
        input_artifacts  = ["build_output"]
        output_artifacts = []
        version          = "1"

        configuration = {
          ProjectName = "deploy-to-staging"
        }
      }
    ]
  }

  approval = {
    name = "Deploy-to-production"
    actions = [{
      run_order        = 1
      name             = "waiting-for-approval"
      category         = "Approval"
      owner            = "AWS"
      provider         = "Manual"
      input_artifacts  = []
      output_artifacts = []
      version          = "1"

      configuration = {}
      },
      {
        run_order        = 2
        name             = "deploy-to-production"
        category         = "Build"
        owner            = "AWS"
        provider         = "CodeBuild"
        input_artifacts  = ["build_output"]
        output_artifacts = []
        version          = "1"

        configuration = {
          ProjectName = "test"
        }
      }
    ]
  }
}

module "mirror" {
  source = "../../modules/codepipeline"

  name                   = "demo-pipeline"
  stages = [
    local.source,
    local.build,
    local.approval
  ]

}

