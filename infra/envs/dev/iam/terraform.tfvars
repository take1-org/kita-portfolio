# ---------------------------------------------
# tfvars/terraform.tfvars
# ---------------------------------------------

gha_url            = "https://token.actions.githubusercontent.com"
gha_client_id_list = ["sts.amazonaws.com"]

tags = {
  Environment = "dev"
  Owner       = "tester-take1"
}

common_tags = {
  Name               = ""
  Project            = "take1-ecs"
  take1-ecs-resource = "true"
}
project     = "take1-ecs"
name_prefix = "take1-dev-ecs"
env         = "dev"

github_owner   = "<<<your-owner>>>"
github_repo    = "<<<your-repository>>>"
ecr_repo_nginx = "take1-ecs-dev-woocommerce-nginx"
ecr_repo_php   = "take1-ecs-dev-woocommerce-php"

allowed_refs = [ # 必要に応じて release/tags なども
  "refs/heads/main",
  "environment:dev-ecs-deploy"
]
account_id = "<<<your-account>>>"
region     = "us-east-1"

kms_key_arns = []
