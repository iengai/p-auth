output "user_pool_id" {
  value = aws_cognito_user_pool.pauth_user_pool.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.pauth_user_pool_client.id
}