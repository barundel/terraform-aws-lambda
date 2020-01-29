locals {
  archive_file_dir = "${path.module}/lib/"
  lambda_permissions = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
  iam_role_arn = coalescelist(aws_iam_role.lambda_role.*.arn, [var.role_arn])

  environment_map = var.variables == null ? [] : [var.variables]


}

resource "random_id" "randomid" {
  byte_length = 4
}

resource "aws_lambda_function" "lambda_function" {
  s3_bucket         = data.aws_s3_bucket_object.object.bucket
  s3_key            = data.aws_s3_bucket_object.object.key
  s3_object_version = data.aws_s3_bucket_object.object.version_id

  function_name = var.function_name
  description = var.description

  handler       = var.handler
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size
  role          = local.iam_role_arn[0]

  dynamic "vpc_config" {
    for_each = var.vpc_config
    content {
      security_group_ids = lookup(vpc_config, "security_group_ids", null)
      subnet_ids = lookup(vpc_config, "subnet_ids", null)
    }
  }

  dynamic "environment" {
    for_each = length(keys(var.variables)) > 0? ["dummy"]:[]
    content {
      variables = var.variables
    }
  }

  tags = var.tags

}



##########
# Lambda Role
##########
resource "aws_iam_role" "lambda_role" {
  count = var.create_role ? 1 : 0

  name = "${var.function_name}-Role-${random_id.randomid.hex}"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_profile.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "attach" {
  count = var.create_role ? length(local.lambda_permissions) : 0

  role       = element(concat(aws_iam_role.lambda_role.*.name, list("")), 0)
  policy_arn = local.lambda_permissions[count.index]
}
