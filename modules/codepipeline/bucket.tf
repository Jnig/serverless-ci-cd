
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket_prefix = "codepipeline"
  acl    = "private"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "codepiline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}