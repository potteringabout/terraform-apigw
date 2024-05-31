# ecs-task

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_task_definition.task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_definitions"></a> [container\_definitions](#input\_container\_definitions) | n/a | <pre>list(object({<br>    name         = string<br>    image        = string<br>    cpu          = number<br>    memory       = number<br>    essential    = bool<br>    portMappings = list(any)<br>  }))</pre> | n/a | yes |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | Role ARN to allow the container agent access to AWS services, Eg. to pull image from ECR | `string` | n/a | yes |
| <a name="input_task_family"></a> [task\_family](#input\_task\_family) | Task Family name | `string` | n/a | yes |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | Role ARN for task execution | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_task_arn"></a> [task\_arn](#output\_task\_arn) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
