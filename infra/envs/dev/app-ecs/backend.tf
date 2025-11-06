# ---------------------------------------------
# backend
# ---------------------------------------------
terraform {

  backend "s3" {
    bucket = "take1-tfstate-bucket"
    #key     = "take1-project-dev.tfstate"
    key     = "tfstate/take1-project/dev/app-ecs/terraform.tfstate"
    region  = "us-east-1"
    profile = "kita-sso"
    #dynamodb_table = "take1-terraform-lock"
    use_lockfile = true
  }

}

