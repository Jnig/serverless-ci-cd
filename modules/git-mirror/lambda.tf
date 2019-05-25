resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.function_name}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}

resource "aws_lambda_function" "lambda" {
  filename         = "${path.module}/handler.zip"
  function_name    = "git-mirror-${var.name}"
  role             = "${aws_iam_role.role.arn}"
  handler          = "handler.handler"
  runtime          = "nodejs10.x"
  source_code_hash = "${filebase64sha256("${path.module}/handler.zip")}"
  timeout          = 30
  memory_size      = 128

  environment {
    variables = {
      project_name = "git-mirror-${var.name}"
    }
  }
}

resource "aws_iam_role" "role" {
  name = "git-mirror-${var.name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "policy" {
  name = "codecommit"
  role = "${aws_iam_role.role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "codebuild:StartBuild",
      "Effect": "Allow",
      "Resource": "arn:aws:codebuild:*:*:project/git-mirror-${var.name}"
    }
  ]
}
EOF
}
