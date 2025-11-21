## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | ../../../modules/app-ecs/alb | n/a |
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | ../../../modules/app-ecs/cluster | n/a |
| <a name="module_ecs_log_group"></a> [ecs\_log\_group](#module\_ecs\_log\_group) | ../../../modules/app-ecs/log-group | n/a |
| <a name="module_ecs_service"></a> [ecs\_service](#module\_ecs\_service) | ../../../modules/app-ecs/service | n/a |
| <a name="module_ecs_task_definition"></a> [ecs\_task\_definition](#module\_ecs\_task\_definition) | ../../../modules/app-ecs/task-definition | n/a |
| <a name="module_ecs_vpc_endpoints"></a> [ecs\_vpc\_endpoints](#module\_ecs\_vpc\_endpoints) | ../../../modules/app-ecs/vpc-endpoints | n/a |
| <a name="module_efs"></a> [efs](#module\_efs) | ../../../modules/app-ecs/efs | n/a |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.app_repository](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.edge](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.foundations](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.iam](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | common tags for all resources | `map(string)` | `{}` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | n/a | `number` | `0` | no |
| <a name="input_ecs_execution_role_arn"></a> [ecs\_execution\_role\_arn](#input\_ecs\_execution\_role\_arn) | n/a | `string` | `""` | no |
| <a name="input_ecs_task_role_arn"></a> [ecs\_task\_role\_arn](#input\_ecs\_task\_role\_arn) | n/a | `string` | `""` | no |
| <a name="input_ecs_tasks_sg_id"></a> [ecs\_tasks\_sg\_id](#input\_ecs\_tasks\_sg\_id) | ECSタスクのSG（EFSがこのSGからの2049を受ける） | `string` | `""` | no |
| <a name="input_efs_access_point_id"></a> [efs\_access\_point\_id](#input\_efs\_access\_point\_id) | n/a | `string` | `""` | no |
| <a name="input_efs_file_system_id"></a> [efs\_file\_system\_id](#input\_efs\_file\_system\_id) | n/a | `string` | `""` | no |
| <a name="input_enable_container_insights"></a> [enable\_container\_insights](#input\_enable\_container\_insights) | n/a | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | `"dev"` | no |
| <a name="input_family_prefix"></a> [family\_prefix](#input\_family\_prefix) | n/a | `string` | `"take1-ecs-woocommerce-app"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | n/a | `string` | `""` | no |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_nginx_environment"></a> [nginx\_environment](#input\_nginx\_environment) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_nginx_image"></a> [nginx\_image](#input\_nginx\_image) | n/a | `string` | `"public.ecr.aws/nginx/nginx:latest"` | no |
| <a name="input_php_environment"></a> [php\_environment](#input\_php\_environment) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_php_image"></a> [php\_image](#input\_php\_image) | n/a | `string` | `"public.ecr.aws/docker/library/php:8.0-fpm"` | no |
| <a name="input_project"></a> [project](#input\_project) | take1 ecs woocommerce project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | Remote state (foundations) location | `string` | n/a | yes |
| <a name="input_remote_state_key"></a> [remote\_state\_key](#input\_remote\_state\_key) | n/a | `string` | n/a | yes |
| <a name="input_remote_state_region"></a> [remote\_state\_region](#input\_remote\_state\_region) | n/a | `string` | n/a | yes |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | The number of days to retain log events in the specified log group. | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_task_cpu"></a> [task\_cpu](#input\_task\_cpu) | Fargate CPU units (as string). e.g., 512 | `string` | n/a | yes |
| <a name="input_task_memory"></a> [task\_memory](#input\_task\_memory) | Fargate memory (MiB) as string. e.g., 1024 | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | The DNS name of the ALB |
| <a name="output_ecs_log_group_arn"></a> [ecs\_log\_group\_arn](#output\_ecs\_log\_group\_arn) | The ARN of the ECS CloudWatch log group |
| <a name="output_ecs_log_group_name"></a> [ecs\_log\_group\_name](#output\_ecs\_log\_group\_name) | The name of the ECS CloudWatch log group |
| <a name="output_ecs_task_definition_arn"></a> [ecs\_task\_definition\_arn](#output\_ecs\_task\_definition\_arn) | The ARN of the ECS task definition |
