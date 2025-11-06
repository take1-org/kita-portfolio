# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  #alias   = "use1"
  profile = "kita-xxx"
  region  = "us-east-1"
}

provider "aws" {
  alias   = "tokyo"
  profile = "kita-xxx-ap"
  region  = "ap-northeast-1"
}

