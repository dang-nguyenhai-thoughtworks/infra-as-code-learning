module "register_user_lambda" {
  source        = "terraform-aws-modules/lambda/aws"
  source_path   = "./lambda/register_user.py"
  function_name = "register_user"
  description   = "Lambda function for user registration"
  handler       = "register_user.lambda_handler"
  runtime       = "python3.8"
  create_role     = false
  attach_cloudwatch_logs_policy = false
  environment_variables = {
    DB_TABLE_NAME = module.dynamodb.dynamodb_table_id
  }
  policies = ["AWSLambdaDynamoDBExecutionRole"]
}

module "verify_user_lambda" {
  source        = "terraform-aws-modules/lambda/aws"
  source_path   = "./lambda/verify_user.py"
  description   = "Lambda function for user verification"
  handler       = "verify_user.lambda_handler"
  runtime       = "python3.8"
  function_name = "register_user"
  create_role     = false
  attach_cloudwatch_logs_policy = false

  environment_variables = {
    DB_TABLE_NAME = module.dynamodb.dynamodb_table_id
    WEBSITE_S3    = module.s3_website.s3_bucket_arn
  }
  policies = ["AWSLambdaDynamoDBExecutionRole"]
}

module "api_gateway" {
  source        = "terraform-aws-modules/apigateway-v2/aws"
  name          = "UserAPI"
  protocol_type = "HTTP"

  create_domain_name    = false
  create_domain_records = false
  
  routes = {
    "GET /" = {
      integration = {
        uri = module.verify_user_lambda.lambda_function_arn
      }
    }
    "GET /register" = {
      integration = {
        uri = module.register_user_lambda.lambda_function_arn
      }
    }
  }
}

module "dynamodb" {
  source     = "terraform-aws-modules/dynamodb-table/aws"
  name       = "UserTable"
  hash_key   = "userId"
  attributes = [{ name = "userId", type = "S" }]
}

module "s3_website" {
  source = "./s3_website"
}


