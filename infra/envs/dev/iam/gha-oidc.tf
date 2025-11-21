# ---------------------------------------------
# iam
# ---------------------------------------------

module "github_oidc_provider" {
  source             = "../../../modules/iam/github-oidc-provider"
  name_prefix        = local.name_prefix
  tags               = var.tags
  common_tags        = var.common_tags
  project            = var.project
  env                = var.env
  gha_url            = var.gha_url
  gha_client_id_list = var.gha_client_id_list
}


module "gha_oidc_role_ecr_push" {
  source      = "../../../modules/iam/gha-oidc-role"
  name_prefix = local.name_prefix
  tags        = var.tags
  common_tags = var.common_tags
  #project            = var.project
  env                = var.env
  gha_url            = var.gha_url
  gha_client_id_list = var.gha_client_id_list
  role_name          = "${local.name_prefix}-gha-ecr-push"
  oidc_provider_arn  = module.github_oidc_provider.arn


  # 信頼ポリシー条件（例）
  github_owner = var.github_owner
  github_repo  = var.github_repo
  allowed_refs = var.allowed_refs # 必要に応じて release/tags なども

  # 付与権限（最小権限でECRに限定）
  managed_policy_arns = [] # 使わないなら空
  inline_policies_json = [
    jsonencode({
      Version = "2012-10-17"
      Statement = [
        # ① ECR ログイン用（必ず *）
        {
          Effect   = "Allow"
          Action   = ["ecr:GetAuthorizationToken"]
          Resource = "*"
        },
        {
          Effect = "Allow"
          Action = [
            # "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload",
            "ecr:PutImage",
            "ecr:BatchGetImage",
            "ecr:GetDownloadUrlForLayer"
          ]
          Resource = [
            "arn:aws:ecr:${var.region}:${var.account_id}:repository/${var.ecr_repo_nginx}",
            "arn:aws:ecr:${var.region}:${var.account_id}:repository/${var.ecr_repo_php}"
          ]
      }]
    })
  ]

}


# ---------------------------------------------
# GitHub Actions 用ロール：Deploy（Terraform/ECS等）
# ---------------------------------------------
module "gha_oidc_role_deploy" {
  source      = "../../../modules/iam/gha-oidc-role"
  name_prefix = local.name_prefix
  tags        = var.tags
  common_tags = var.common_tags
  #project            = var.project
  env                = var.env
  gha_url            = var.gha_url
  gha_client_id_list = var.gha_client_id_list

  role_name         = "${local.name_prefix}-gha-deploy"
  oidc_provider_arn = module.github_oidc_provider.arn
  github_owner      = var.github_owner
  github_repo       = var.github_repo
  allowed_refs      = var.allowed_refs # 環境別にロールを分けるなら ref も分離

  # 例：必要最小の権限（ARNやタグで極力限定）
  inline_policies_json = [
    jsonencode({
      Version = "2012-10-17"
      Statement = [
        # --- ECS 更新系（既存） ---
        {
          Effect = "Allow"
          Action = [
            "ecs:UpdateService",
            "ecs:RegisterTaskDefinition",
            "ecs:DeregisterTaskDefinition",
            "ecs:Describe*",
            "ecs:TagResource",        # +2025.11.20
            "ecs:ListTagsForResource" # +2025.11.20
          ]
          Resource = "*"
        },
        #--- iam:PassRole ---
        {
          Effect = "Allow"
          Action = ["iam:PassRole"]
          Resource = [
            "arn:aws:iam::${var.account_id}:role/${local.name_prefix}-execution-role",
            "arn:aws:iam::${var.account_id}:role/${local.name_prefix}-task-role"
          ]
          Condition = {
            StringEquals = {
              "iam:PassedToService" = "ecs-tasks.amazonaws.com"
            }
          }
        },
        # --- S3: tfstate バケット (List/GetBucketLocation) 既存分 ---
        {
          Effect = "Allow"
          Action = [
            "s3:ListBucket",
            "s3:GetBucketLocation"
          ]
          Resource = "arn:aws:s3:::take1-tfstate-bucket"
          Condition = {
            StringLike = {
              "s3:prefix" = "tfstate/take1-project/dev/*"
            }
          }
        },

        # --- S3: tfstate オブジェクト操作 既存分 ---
        {
          Effect = "Allow"
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject"
          ]
          Resource = "arn:aws:s3:::take1-tfstate-bucket/tfstate/take1-project/dev/*"
        },

        # --- DynamoDB: tfstate ロックテーブル 既存分 ---
        {
          Effect = "Allow"
          Action = [
            "dynamodb:GetItem",
            "dynamodb:PutItem",
            "dynamodb:DeleteItem",
            "dynamodb:UpdateItem",
            "dynamodb:DescribeTable"
          ]
          Resource = "arn:aws:dynamodb:us-east-1:${var.account_id}:table/take1-terraform-lock"
        },

        # ---  ALB / Target Group / Listener 操作用（追加） ---
        {
          Effect = "Allow"
          Action = [
            # 読み取り
            "elasticloadbalancing:DescribeLoadBalancers",
            "elasticloadbalancing:DescribeTargetGroupAttributes", #
            "elasticloadbalancing:DescribeTargetGroups",
            "elasticloadbalancing:DescribeListeners",
            "elasticloadbalancing:DescribeRules",
            "elasticloadbalancing:DescribeTags",
            # 作成・更新・削除（必要に応じて）
            "elasticloadbalancing:CreateLoadBalancer",
            "elasticloadbalancing:DeleteLoadBalancer",
            "elasticloadbalancing:CreateTargetGroup",
            "elasticloadbalancing:ModifyTargetGroup",
            "elasticloadbalancing:DeleteTargetGroup",
            "elasticloadbalancing:CreateListener",
            "elasticloadbalancing:ModifyListener",
            "elasticloadbalancing:DeleteListener",

            # （タグの追加削除）
            "elasticloadbalancing:AddTags",
            "elasticloadbalancing:RemoveTags",
          ]
          Resource = "*"
        },

        # ---  Security Group 操作用（追加） ---
        {
          Effect = "Allow"
          Action = [
            "ec2:DescribeSecurityGroups",
            "ec2:CreateSecurityGroup",
            "ec2:DeleteSecurityGroup",
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:RevokeSecurityGroupIngress",
            "ec2:AuthorizeSecurityGroupEgress",
            "ec2:RevokeSecurityGroupEgress",

            # 参照系（必要に応じて）
            "ec2:DescribeVpcs",
            "ec2:DescribeSubnets",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DescribeSecurityGroupRules"
          ]
          Resource = "*"
        },

        # ---  CloudWatch Logs（ECS 用 Log Group）操作（追加） ---
        {
          Effect = "Allow"
          Action = [
            "logs:ListTagsForResource",
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams",
            "logs:PutLogEvents",
            "logs:PutRetentionPolicy"
          ]
          Resource = "*"
        },

        # --- SSM Parameter Store 参照（DB パスワードなど読む場合用・任意） ---
        {
          Effect = "Allow"
          Action = [
            "ssm:GetParameter",
            "ssm:GetParameters",
            "ssm:GetParametersByPath"
          ]
          Resource = "*"
        }
      ]
    })
  ]

}


