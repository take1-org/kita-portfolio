# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  #alias   = "use1"
  profile = "kita-sso"
  region  = "us-east-1"
}

provider "aws" {
  alias   = "tokyo"
  profile = "kita-sso-ap"
  region  = "ap-northeast-1"
}

