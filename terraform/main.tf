module "cognito" {
  source  = "./modules/aws/cognito"
  service = var.service
  stage   = var.stage
}
#
# module "iam" {
#   source  = "./modules/aws/iam"
#   service = var.service
#   stage   = var.stage
# }
#
# module "api_gateway" {
#   source  = "./modules/aws/api_gateway"
#   service = var.service
#   stage   = var.stage
#   region  = var.region
# }
#
