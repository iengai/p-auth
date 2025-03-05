variable "region" {
  description = "AWS region"
  default     = "ap-northeast-1"
}

variable "stage" {
  description = "Deployment stage"
  default     = "dev"
}

variable "service" {
  description = "Service name"
  default     = "pauth"
}

variable "aws_profile" {
  description = "AWS profile to use"
  default     = "default"
}
