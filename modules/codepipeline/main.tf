variable "codecommit_repo_name" {

}

variable "codecommit_repo_branch" {

}

variable "stages" {

}


resource "aws_codepipeline" "codepipeline" {
  name     = "tf-test-pipeline"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.codepipeline_bucket.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = var.codecommit_repo_name
        BranchName     = var.codecommit_repo_branch
      }
    }
  }

  dynamic "stage" {
    for_each = var.stages
    content {
      name = stage.value.name
      dynamic "action" {
        for_each = stage.value.actions
        name             = stage.value.action.name
        category         = stage.value.action.category
        owner            = stage.value.action.owner
        provider         = stage.value.action.provider
        input_artifacts  = stage.value.action.input_artifacts
        output_artifacts = stage.value.action.output_artifacts
        version          = stage.value.action.version

        configuration = stage.value.action.configuration
      }
    }
  }
}
