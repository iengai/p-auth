variable "service" {}
variable "stage" {}

variable "lambda_triggers" {}

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

  # sign_in_policy {
  #   allowed_first_auth_factors = ["EMAIL_OTP"]
  # }

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
  # todo use aws native passwordless support : https://docs.aws.amazon.com/cognito/latest/developerguide/amazon-cognito-user-pools-authentication-flow-methods.html#amazon-cognito-user-pools-authentication-flow-methods-passwordless
  #│ Error: updating Cognito User Pool (ap-northeast-1_KXaNM898u): operation error Cognito Identity Provider: UpdateUserPool, https response error StatusCode: 400, RequestID: 8fddc931-30c7-4b12-a96c-b55aa9b2afff, InvalidParameterException: Password should be configured as one of the allowed first auth factors.
  #│
  #│   with module.cognito.aws_cognito_user_pool.pauth_user_pool,
  #│   on modules\aws\cognito\main.tf line 8, in resource "aws_cognito_user_pool" "pauth_user_pool":
  #│    8: resource "aws_cognito_user_pool" "pauth_user_pool" {
  # explicit_auth_flows = ["ALLOW_USER_AUTH"]

}

resource "aws_lambda_permission" "cognito_triggers" {
  for_each = var.lambda_triggers

  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.pauth_user_pool.arn
}