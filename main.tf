locals {
  archive_file_dir = "${path.module}/lib/"
  lambda_permissions = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
}



resource "aws_lambda_function" "lambda_function" {
  s3_bucket         = data.aws_s3_bucket_object.object.bucket
  s3_key            = data.aws_s3_bucket_object.object.key
  s3_object_version = data.aws_s3_bucket_object.object.version_id

  # lambda description
  # lambda memory

  function_name = var.function_name
  description = var.description

  handler       = var.handler
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size
  role          = var.role



  dynamic "vpc_config" {
    for_each = var.vpc_config
    content {
      security_group_ids = lookup(vpc_config, "security_group_ids", null)
      subnet_ids = lookup(vpc_config, "subnet_ids", null)
    }
  }

  environment {
    variables = var.variables
  }

  # Not sure of a better way to conditional a block.
  #The environment block only takes "variables" therefore seems silly to require users to input a complete environment{variables={}}
//  dynamic "environment" {
//    for_each = length(keys(var.environment_variables)) > 0? ["dummy"]:[]
//    content {
//      variables = var.environment_variables
//    }
//  }


  tags = var.tags
}



##########
# Suspend Lambda
##########

resource "aws_iam_role" "lambda_role" {
  name = "${var.function_name}-Role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_profile.json
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "attach" {
  count = length(local.lambda_permissions)
  role       = aws_iam_role.lambda_role.name
  policy_arn = element(local.lambda_permissions, count.index)
}



