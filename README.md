# terraform-aws-lambda [![Build Status](https://github.com/barundel/terraform-aws-lambda/workflows/release/badge.svg)](https://github.com/barundel/terraform-aws-lambda/actions)   [![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)


> **A Terraform module for creating Lambda resources.**

## Table of Contents

- [Maintenance](#maintenance)
- [Getting Started](#getting-started)
- [License](#license)

## Maintenance

This project is maintained [Ben](https://github.com/barundel), anyone is welcome to contribute. 

TODO:
* Support CloudWatch Log Groups 

## Getting Started

This module will create a lambda function based on your inputs. As default it will also create a basic IAM role and attach it to the function, this basic role will give the lambda the ability to log to CloudWatch. You can override this by passing in your own IAM Role ARN or you can amend the permissions of the basic role by passing in a list of extra IAM Policy ARNs.

#### Simple Example
````
module "lambda_1" {

  source = "git::github.com/barundel/terraform-aws-lambda?ref=v1.0.0"

  artifact_bucket = "name_of_your_bucket"
  function_name = "your_function"
  handler = "hello.handler"
  path_to_lambda_object = "the_s3_path.zip"
  runtime = "provided"

}
````

<!--- BEGIN_TF_DOCS --->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| artifact\_bucket | The S3 bucket where the Lambda source code exists | `any` | n/a | yes |
| create\_role | Tue or False on if to create the default role. Set to false if your going to pass in your own role via the var role\_arn | `bool` | `true` | no |
| description | Description of what your Lambda Function does | `string` | `""` | no |
| extra\_policy\_arns | Extra policy ARNs to attach to the Lambda role | `list(string)` | `[]` | no |
| function\_name | A unique name for your Lambda Function | `any` | n/a | yes |
| handler | The function entrypoint in your code | `any` | n/a | yes |
| lambda\_alias | List of Aliases to assign lambda function. | `any` | n/a | yes |
| memory\_size | Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128. See [Limits](https://docs.aws.amazon.com/lambda/latest/dg/limits.html) | `number` | `128` | no |
| path\_to\_lambda\_object | The path to the object in the S3 bucket | `any` | n/a | yes |
| publish | True or False on if to publish lambda | `bool` | `true` | no |
| reserved\_concurrent\_executions | The amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1. See [Managing Concurrency](https://docs.aws.amazon.com/lambda/latest/dg/scaling.html) | `number` | `-1` | no |
| role\_arn | IAM role attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to | `string` | `""` | no |
| runtime | See [documentation](https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime) for valid values | `any` | n/a | yes |
| security\_group\_ids | List of security group IDs to asign to your lambda if in a vpc. | `list` | `[]` | no |
| subnet\_ids | List of SubnetIDs to house your lambda inside a vpc | `list` | `[]` | no |
| tags | Map of tags to assign to the resources | `map` | `{}` | no |
| timeout | The amount of time your Lambda Function has to run in seconds. Defaults to 3. See [Limits](https://docs.aws.amazon.com/lambda/latest/dg/limits.html) | `number` | `3` | no |
| variables | A map that defines environment variables for the Lambda function | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| invoke\_arn | The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws\_api\_gateway\_integration's uri |
| lambda\_alias\_arn | Lambda Alias ARN |
| lambda\_alias\_invoke\_arn | Lambda Alias Invoke ARN |
| lambda\_arn | The Amazon Resource Name (ARN) identifying your Lambda Function |
| qualified\_arn | The Amazon Resource Name (ARN) identifying your Lambda Function Version (if versioning is enabled via publish = true). |

<!--- END_TF_DOCS --->

## License

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.