output "lambda_arn" {
  value = aws_lambda_function.lambda_function.arn
  description = "The Amazon Resource Name (ARN) identifying your Lambda Function"
}

output "qualified_arn" {
  value = aws_lambda_function.lambda_function.qualified_arn
  description = "The Amazon Resource Name (ARN) identifying your Lambda Function Version (if versioning is enabled via publish = true)."
}

output "invoke_arn" {
  value = aws_lambda_function.lambda_function.invoke_arn
  description = "The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri"
}

output "lambda_alias_arn" {
  value = aws_lambda_alias.lambda_alias.*.arn
  description = "Lambda Alias ARN"
}

output "lambda_function_name" {
  value = aws_lambda_function.lambda_function.function_name
  description = "Function name of the lambda."
}

output "lambda_alias_invoke_arn" {
  value = aws_lambda_alias.lambda_alias.*.invoke_arn
  description = "Lambda Alias Invoke ARN"
}

//output "test" {
//  value = {
//    test = var.lambda_alias
//  }
//}