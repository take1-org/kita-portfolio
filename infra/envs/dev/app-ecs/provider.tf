# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "tokyo"
  region = "ap-northeast-1"
}

