output "define_auth_arn" {
  value = aws_lambda_function.define_auth.arn
}

output "create_auth_arn" {
  value = aws_lambda_function.create_auth.arn
}

output "verify_auth_arn" {
  value = aws_lambda_function.verify_auth.arn
}

output "pre_sign_up_arn" {
  value = aws_lambda_function.pre_sign.arn
}

output "post_auth_arn" {
  value = aws_lambda_function.post_auth.arn
}