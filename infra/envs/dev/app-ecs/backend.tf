# ---------------------------------------------
# backend
# ---------------------------------------------
terraform {

  backend "s3" {
    bucket         = "<<<your-backend-bucket>>>"
    key            = "tfstate/<<<your-project>>>/dev/app-ecs/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "<<<your-lock-table>>>"
    #use_lockfile = true
  }
}
