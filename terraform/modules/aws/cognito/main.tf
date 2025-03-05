variable "service" {
  default = ""
}
variable "stage" {
  default = ""
}

# change pauth_user_pool
resource "aws_cognito_user_pool" "pauth_user_pool" {
  name = "${var.service}-${var.stage}-user-pool"

  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_lowercase = false
    require_numbers   = false
    require_symbols   = false
    require_uppercase = false
  }

  username_attributes = ["email"]
}
# change pauth_user_pool_client
resource "aws_cognito_user_pool_client" "pauth_user_pool_client" {
  name         = "${var.service}-${var.stage}-user-pool-client"
  user_pool_id = aws_cognito_user_pool.pauth_user_pool.id
  generate_secret = false

  explicit_auth_flows = ["CUSTOM_AUTH_FLOW_ONLY"]
}
