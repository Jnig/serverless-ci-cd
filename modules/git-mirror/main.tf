data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

variable name {
}

variable ssh_key {

}

variable git_repo {
}

output webhook_url {
  value =  "${aws_api_gateway_deployment.prod.invoke_url}${aws_api_gateway_resource.resource.path}"
}

