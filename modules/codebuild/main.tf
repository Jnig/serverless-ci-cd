variable name {

}

variable docker_image {

}

variable artifacts {
  default = "NO_ARTIFACTS"
}

variable buildspec {
  default = ""
}

variable cache_bucket {
  default = ""
}

resource "aws_iam_role" "codebuild" {
  name = "codebuild-${var.name}"

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
            "Effect": "Allow",
            "Action": [
                "ec2:CreateNetworkInterfacePermission"
            ],
            "Resource": "arn:aws:ec2:*:*:network-interface/*"
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:*:*:log-group:/aws/codebuild/${var.name}",
                "arn:aws:logs:*:*:log-group:/aws/codebuild/${var.name}:*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
          "Effect":"Allow",
          "Action": [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:GetBucketAcl",
            "s3:GetBucketLocation"
          ],
          "Resource": [
            "arn:aws:s3:::codepipeline-*"
          ]
        }

    ]
}
POLICY
}


resource "aws_codebuild_project" "project" {
  name          = "${var.name}"
  description   = "${var.name}"
  build_timeout = "30"
  service_role  = "${aws_iam_role.codebuild.arn}"

  artifacts {
    type = var.artifacts
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.docker_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  source {
    type      = var.artifacts == "NO_ARTIFACTS" ? "NO_SOURCE" : var.artifacts
    buildspec = var.buildspec
  }

  cache {
    type     = "S3"
    location = "${var.cache_bucket}/cache"
  } 

}
