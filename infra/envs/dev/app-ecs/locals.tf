# ---------------------------------------------
# locals ecs
# ---------------------------------------------
locals {
  name_prefix = "${var.project}-${var.env}-ecs"

  # remote state(foundations) から map で受ける
  all_subnet_ids_map = data.terraform_remote_state.foundations.outputs.all_subnet_ids     # map(string) 修正 2025.11.4
  private_subnet_ids = data.terraform_remote_state.foundations.outputs.private_subnet_ids # map (string) 修正 2025.11.4
  public_subnet_ids  = data.terraform_remote_state.foundations.outputs.public_subnet_ids  # map (string) 修正 2025.11.4
  azs_map            = data.terraform_remote_state.foundations.outputs.all_subnet_azs     # map(string) 修正 2025.11.4
  vpc_id             = data.terraform_remote_state.foundations.outputs.vpc_id
  vpc_cidr           = data.terraform_remote_state.foundations.outputs.vpc_cidr_block


  #reomte state(iam) から受ける
  ecs_execution_role_arn = data.terraform_remote_state.iam.outputs.ecs_execution_role_arn
  ecs_task_role_arn      = data.terraform_remote_state.iam.outputs.ecs_task_role_arn

  # remote state(app_repository) から受ける
  #************************************************************************************************************************************
  # image_tag = "372f419-1" # 固定値。CI/CD連携で動的にする場合は変更予定   *********************************************************
  #************************************************************************************************************************************
  php_image   = "${data.terraform_remote_state.app_repository.outputs.ecr_repository_urls["php"]}:${var.image_tag}"
  nginx_image = "${data.terraform_remote_state.app_repository.outputs.ecr_repository_urls["nginx"]}:${var.image_tag}"


  # 1AZだけ使う（検証用）
  target_az = "us-east-1a"

  # キーが "private_*" かつ target_az の subnet を 1つ取得
  private_subnet_id_1a = one([
    for k, id in local.all_subnet_ids_map :
    id
    if startswith(k, "private_") && local.azs_map[k] == local.target_az
  ])

  acm_cert_arn = data.terraform_remote_state.edge.outputs.edge_acm_arn #acm
}

