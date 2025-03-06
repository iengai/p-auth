output "lambda_exec_role_arn" {
  value = aws_iam_role.lambda_exec.arn
}

output "ses_send_role_arn" {
  value = aws_iam_role.ses_sender.arn
}

output "cognito_update_role_arn" {
  value = aws_iam_role.cognito_updater.arn
}