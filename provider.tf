# -----------------------
# Terraform Configuration
# -----------------------
terraform {
  required_version = "1.0.7"
}

# -----------------------
# aws provider
# -----------------------
provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}