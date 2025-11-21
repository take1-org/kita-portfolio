## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_execution_role"></a> [ecs\_execution\_role](#module\_ecs\_execution\_role) | ../../../modules/iam/ecs-execution-role | n/a |
| <a name="module_ecs_task_role"></a> [ecs\_task\_role](#module\_ecs\_task\_role) | ../../../modules/iam/ecs-task-role | n/a |
| <a name="module_gha_oidc_role_deploy"></a> [gha\_oidc\_role\_deploy](#module\_gha\_oidc\_role\_deploy) | ../../../modules/iam/gha-oidc-role | n/a |
| <a name="module_gha_oidc_role_ecr_push"></a> [gha\_oidc\_role\_ecr\_push](#module\_gha\_oidc\_role\_ecr\_push) | ../../../modules/iam/gha-oidc-role | n/a |
| <a name="module_github_oidc_provider"></a> [github\_oidc\_provider](#module\_github\_oidc\_provider) | ../../../modules/iam/github-oidc-provider | n/a |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.app_data](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AWS Account ID | `string` | `""` | no |
| <a name="input_allowed_refs"></a> [allowed\_refs](#input\_allowed\_refs) | GitHub repository refs allowed to assume the role | `list(string)` | `[]` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | common tags for all resources | `map(string)` | `{}` | no |
| <a name="input_ecr_repo_nginx"></a> [ecr\_repo\_nginx](#input\_ecr\_repo\_nginx) | ecr repository name | `string` | `""` | no |
| <a name="input_ecr_repo_php"></a> [ecr\_repo\_php](#input\_ecr\_repo\_php) | ecr repository name | `string` | `""` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | `"dev"` | no |
| <a name="input_gha_client_id_list"></a> [gha\_client\_id\_list](#input\_gha\_client\_id\_list) | GitHub Actions OIDC Client ID | `list(string)` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_gha_url"></a> [gha\_url](#input\_gha\_url) | GitHub Actions OIDC Provider URL | `string` | `""` | no |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | GitHub organization or user name | `string` | `""` | no |
| <a name="input_github_repo"></a> [github\_repo](#input\_github\_repo) | GitHub repository name | `string` | `""` | no |
| <a name="input_kms_key_arns"></a> [kms\_key\_arns](#input\_kms\_key\_arns) | n/a | `list(string)` | `[]` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | n/a | `string` | `""` | no |
| <a name="input_project"></a> [project](#input\_project) | take1 ecs woocomerce project name | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"us-east-1"` | no |
| <a name="input_s3_bucket_arns"></a> [s3\_bucket\_arns](#input\_s3\_bucket\_arns) | n/a | `list(string)` | `[]` | no |
| <a name="input_s3_object_arns"></a> [s3\_object\_arns](#input\_s3\_object\_arns) | n/a | `list(string)` | `[]` | no |
| <a name="input_secretsmanager_arns"></a> [secretsmanager\_arns](#input\_secretsmanager\_arns) | n/a | `list(string)` | `[]` | no |
| <a name="input_ssm_parameter_arns"></a> [ssm\_parameter\_arns](#input\_ssm\_parameter\_arns) | n/a | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | --------------------------------------------- variables.tf --------------------------------------------- | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_execution_role_arn"></a> [ecs\_execution\_role\_arn](#output\_ecs\_execution\_role\_arn) | n/a |
| <a name="output_ecs_execution_role_name"></a> [ecs\_execution\_role\_name](#output\_ecs\_execution\_role\_name) | --------------------------------------------- outputs for ecs-execution-rol --------------------------------------------- |
| <a name="output_ecs_task_role_arn"></a> [ecs\_task\_role\_arn](#output\_ecs\_task\_role\_arn) | n/a |
| <a name="output_ecs_task_role_name"></a> [ecs\_task\_role\_name](#output\_ecs\_task\_role\_name) | n/a |
