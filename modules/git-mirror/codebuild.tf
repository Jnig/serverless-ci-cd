

resource "aws_iam_role" "codebuild" {
  name = "git-mirror-${var.name}-codebuild"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_policy" {
  role = "${aws_iam_role.codebuild.name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
    {
      "Action": "codecommit:*",
      "Effect": "Allow",
      "Resource": "arn:aws:codecommit:*:*:*"
    }
  ]
}
POLICY
}


resource "aws_codebuild_project" "project" {
  name          = "git-mirror-${var.name}"
  description   = "test_codebuild_project_cache"
  build_timeout = "5"
  service_role  = "${aws_iam_role.codebuild.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "jnig/serverless-ci-cd-mirror"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
     name  = "SECRET_NAME"
     value = "git-mirror-${var.name}"
    }

    environment_variable {
     name  = "SOURCE_REPO"
     value = var.git_repo 
    }

    environment_variable {
     name  = "TARGET_REPO"
     value = aws_codecommit_repository.repo.clone_url_http
    }
  }

  source {
    type            = "NO_SOURCE"
    buildspec       = <<EOF
version: 0.2         
phases:
  build:
    commands:
      - /usr/local/bin/mirror.sh 
    EOF
  }

}