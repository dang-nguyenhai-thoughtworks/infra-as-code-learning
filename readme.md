# Structure

This folder contains 5 modules:

## 2 lambda modules for 2 lambda functions: "register_user_lambda" & "verify_user_lambda"
From [github source](https://github.com/terraform-aws-modules/terraform-aws-lambda)

## module "api_gateway"
From [github source](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2)

## module "dynamodb"
From [github source](https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table)

## module "s3_website"
This is custom module from folder s3_website because it contains module "s3_bucket" and 2 terraform resources "aws_s3_object" for index.html and error.html