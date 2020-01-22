variable "function_name" {
  description = "A unique name for your Lambda Function"
}

variable "handler" {
  description = "The function entrypoint in your code"
}

variable "role" {
  description = "IAM role attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to."
  default = ""
}

variable "runtime" {
  description = "See [documentation](https://github.com/barundel/terraform-aws-logging/tree/master/README.md) for valid values"
}

variable "tags" {
  description = "Map of tags to assign to the resources"
  default = {}
}

variable "artifact_bucket" {
  description = "The S3 bucket where the Lambda source code exists."
}

variable "path_to_lambda_object" {
  description = "The path to the object in the S3 bucket."
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds. Defaults to 3. See [Limits](https://docs.aws.amazon.com/lambda/latest/dg/limits.html)"
  default = 3
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128. See [Limits](https://docs.aws.amazon.com/lambda/latest/dg/limits.html)"
  default = 128
}

variable "variables" {
  default = {}
  description = "A map that defines environment variables for the Lambda function"
}

variable "vpc_config" {
  description = "Provide this to allow your function to access your VPC"
  default = {}
  type = any
}

variable "reserved_concurrent_executions" {
  default = -1
  description = "The amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1. See [Managing Concurrency](https://docs.aws.amazon.com/lambda/latest/dg/scaling.html)"
}

variable "description" {
  default = ""
  description = "Description of what your Lambda Function does"
}