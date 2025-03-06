variable "service" {}
variable "stage" {}
variable "lambda_exec_role_arn" {}
variable "ses_send_role_arn" {}
variable "cognito_update_arn" {}
variable "lambda_runtime" {}

resource "aws_lambda_function" "define_auth" {
  function_name = "${var.service}-${var.stage}-define-auth-challenge"
  handler       = "lambda_function.handler"
  runtime       = var.lambda_runtime
  role          = var.lambda_exec_role_arn
  filename      = "${path.root}/scripts/lambda_function_placeholder.zip"
}

resource "aws_lambda_function" "create_auth" {
  function_name = "${var.service}-${var.stage}-create-auth-challenge"
  handler       = "lambda_function.handler"
  runtime       = var.lambda_runtime
  role          = var.ses_send_role_arn
  filename      = "${path.root}/scripts/lambda_function_placeholder.zip"
}

resource "aws_lambda_function" "verify_auth" {
  function_name = "${var.service}-${var.stage}-verify-auth-challenge"
  handler       = "lambda_function.handler"
  runtime       = var.lambda_runtime
  role          = var.lambda_exec_role_arn
  filename      = "${path.root}/scripts/lambda_function_placeholder.zip"
}

resource "aws_lambda_function" "pre_sign" {
  function_name = "${var.service}-${var.stage}-pre-sign"
  handler       = "lambda_function.handler"
  runtime       = var.lambda_runtime
  role          = var.lambda_exec_role_arn
  filename      = "${path.root}/scripts/lambda_function_placeholder.zip"
}

resource "aws_lambda_function" "post_confirmation" {
  function_name = "${var.service}-${var.stage}-post-confirmation"
  handler       = "lambda_function.handler"
  runtime       = var.lambda_runtime
  role          = var.lambda_exec_role_arn
  filename      = "${path.root}/scripts/lambda_function_placeholder.zip"
}

resource "aws_lambda_function" "post_auth" {
  function_name = "${var.service}-${var.stage}-post-authentication"
  handler       = "lambda_function.handler"
  runtime       = var.lambda_runtime
  role          = var.cognito_update_arn
  filename      = "${path.root}/scripts/lambda_function_placeholder.zip"
}
