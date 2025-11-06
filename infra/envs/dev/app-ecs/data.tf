# ---------------------------------------------
# data for app-ecs
# ---------------------------------------------
#foundations スタックのstateを参照（vpc,subnetを取得する）

data "terraform_remote_state" "foundations" {
  backend = "s3"
  config = {
    bucket  = var.remote_state_bucket
    key     = var.remote_state_key
    region  = var.remote_state_region
    profile = "kita-sso"
  }
}
# ---------------------------------------------
# Remote state: IAM Stack (execution/task role)
# ---------------------------------------------
data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "take1-tfstate-bucket"
    key    = "tfstate/take1-project/dev/iam/terraform.tfstate"
    region = "us-east-1"
  }
}

# ---------------------------------------------
# Remote state: ECR Stack (php / nginx images)
# ---------------------------------------------
data "terraform_remote_state" "app_repository" {
  backend = "s3"
  config = {
    bucket = "take1-tfstate-bucket"
    key    = "tfstate/take1-project/dev/app-repository/terraform.tfstate"
    region = "us-east-1"
  }
}

# ---------------------------------------------
# Remote state: Edge Stack (cloudfront/acm)
# ---------------------------------------------
data "terraform_remote_state" "edge" {
  backend = "s3"
  config = {
    bucket = "take1-tfstate-bucket"
    key    = "tfstate/take1-project/dev/edge/terraform.tfstate"
    region = "us-east-1"
  }
}

