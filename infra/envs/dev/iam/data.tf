# ---------------------------------------------
# data for ecs task role
# ---------------------------------------------
data "terraform_remote_state" "app_data" {
  backend = "s3"
  config = {
    bucket = "take1-tfstate-bucket"
    key    = "tfstate/take1-project/dev/app-data/terraform.tfstate"
    region = "us-east-1"
  }
}
