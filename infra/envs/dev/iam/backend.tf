# ---------------------------------------------
# backend
# ---------------------------------------------
terraform {
  backend "s3" {
    bucket       = "<<<your-backend-bucket>>>"
    key          = "tfstate/<<<your-project>>>/dev/iam/terraform.tfstate"
    region       = "us-east-1"
    profile      = "xxxxxxx"
    use_lockfile = true
  }

}

