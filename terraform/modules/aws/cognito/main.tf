variable "service" {}
variable "stage" {}

variable "lambda_triggers" {}

# todo passwordless sign-in is native supported. https://aws.amazon.com/jp/blogs/aws/improve-your-app-authentication-workflow-with-new-amazon-cognito-features/
# change pauth_user_pool
resource "aws_cognito_user_pool" "pauth_user_pool" {
  name = "${var.service}-${var.stage}-user-pool"

  lambda_config {
    define_auth_challenge          = var.lambda_triggers.define_auth
    create_auth_challenge          = var.lambda_triggers.create_auth
    verify_auth_challenge_response = var.lambda_triggers.verify_auth
    pre_sign_up                    = var.lambda_triggers.pre_sign_up
    post_authentication            = var.lambda_triggers.post_auth
  }

  username_attributes = ["email"]
  auto_verified_attributes = ["email"]
  mfa_configuration   = "OFF"
}
# change pauth_user_pool_client
resource "aws_cognito_user_pool_client" "pauth_user_pool_client" {
  name         = "${var.service}-${var.stage}-user-pool-client"
  user_pool_id = aws_cognito_user_pool.pauth_user_pool.id
  generate_secret = false

  explicit_auth_flows = ["CUSTOM_AUTH_FLOW_ONLY"]
}

resource "aws_lambda_permission" "cognito_triggers" {
  for_each = var.lambda_triggers

  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.pauth_user_pool.arn
}