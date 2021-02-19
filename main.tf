locals {
  archive_file_dir = "${path.module}/lib/"

  lambda_permissions = concat([
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"],
    var.extra_policy_arns
  )

  iam_role_arn = coalescelist(aws_iam_role.lambda_role.*.arn, [
    var.role_arn])

  environment_map = var.variables == null ? [] : [
    var.variables]


}

variable "bucket_config" {
  type = map(string)
  description = "Bucket config to avoid data lookup"
  default = null
}

resource "random_id" "randomid" {
  byte_length = 4
}

resource "aws_lambda_function" "lambda_function" {
  s3_bucket = length(var.bucket_config) > 0 ? lookup(var.bucket_config, "bucket") : concat(data.aws_s3_bucket_object.object.*.bucket, [""])[0]
  s3_key = length(var.bucket_config) > 0 ? lookup(var.bucket_config, "key") : concat(data.aws_s3_bucket_object.object.*.key, [""])[0]
  s3_object_version = length(var.bucket_config) > 0 ? lookup(var.bucket_config, "version_id") : concat(data.aws_s3_bucket_object.object.*.version_id, [""])[0]

  function_name = var.function_name
  description = var.description

  publish = var.publish

  handler = var.handler
  runtime = var.runtime
  timeout = var.timeout
  memory_size = var.memory_size
  role = local.iam_role_arn[0]

  vpc_config {
    security_group_ids = var.security_group_ids
    subnet_ids = var.subnet_ids
  }

  dynamic "environment" {
    for_each = length(keys(var.variables)) > 0? [
      "dummy"]:[]
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

  role = element(concat(aws_iam_role.lambda_role.*.name, list("")), 0)
  policy_arn = element(local.lambda_permissions, count.index)
}

##########
# Lambda Alias
##########
resource "aws_lambda_alias" "lambda_alias" {
  count = length(var.lambda_alias) > 0 ? length(var.lambda_alias) : 0

  name             = var.lambda_alias[count.index]
  function_name    = aws_lambda_function.lambda_function.arn
  function_version = "$LATEST"

}



