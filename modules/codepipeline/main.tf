variable "stages" {

}

variable "name" {

}


resource "aws_codepipeline" "codepipeline" {
  name     = var.name
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.codepipeline_bucket.bucket}"
    type     = "S3"
  }

  dynamic "stage" {
    for_each = var.stages
    content {
      name = stage.value.name

      dynamic "action" {
        for_each = stage.value.actions

        content {
          name             = action.value.name
          category         = action.value.category
          owner            = action.value.owner
          provider         = action.value.provider
          input_artifacts  = action.value.input_artifacts
          output_artifacts = action.value.output_artifacts
          version          = action.value.version
          run_order        = contains(keys(action.value), "run_order") ? action.value.run_order : 1

          configuration = action.value.configuration
        }
      }
    }
  }
}
