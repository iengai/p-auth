variable "service" {}
variable "stage" {}

resource "aws_iam_role" "lambda_exec" {
  name               = "${var.service}-${var.stage}-lambda-exec-base"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

resource "aws_iam_role" "ses_sender" {
  name               = "${var.service}-${var.stage}-ses-sender-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

resource "aws_iam_role" "cognito_updater" {
  name               = "${var.service}-${var.stage}-cognito-updater-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  for_each = toset([
    aws_iam_role.lambda_exec.name,
    aws_iam_role.ses_sender.name,
    aws_iam_role.cognito_updater.name
  ])
  
  role       = each.value
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "ses_send" {
  name = "${var.service}-${var.stage}-ses-send-policy"
  role = aws_iam_role.ses_sender.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "ses:SendEmail",
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy" "cognito_update" {
  name = "${var.service}-${var.stage}-cognito-update-policy"
  role = aws_iam_role.cognito_updater.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "cognito-idp:AdminUpdateUserAttributes",
      Resource = "*"
    }]
  })
}
