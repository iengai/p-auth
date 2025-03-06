module "cognito" {
  source  = "./modules/aws/cognito"
  lambda_triggers = {
    define_auth   = module.lambda.define_auth_arn
    create_auth   = module.lambda.create_auth_arn
    verify_auth   = module.lambda.verify_auth_arn
    pre_sign_up   = module.lambda.pre_sign_up_arn
    post_auth     = module.lambda.post_auth_arn
  }
  service = var.service
  stage   = var.stage
}

module "iam" {
  source  = "./modules/aws/iam"
  service = var.service
  stage   = var.stage
}

module "lambda" {
  source = "./modules/aws/lambda"
  lambda_exec_role_arn = module.iam.lambda_exec_role_arn
  ses_send_role_arn    = module.iam.ses_send_role_arn
  cognito_update_arn   = module.iam.cognito_update_role_arn
  lambda_runtime       = var.lambda_runtime
  service = var.service
  stage   = var.stage
}

