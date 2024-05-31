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
| [aws_ecs_service.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_security_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.allow_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.allow_3128](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ecs_cluster_id"></a> [ecs\_cluster\_id](#input\_ecs\_cluster\_id) | ECS Cluster Id | `string` | n/a | yes |
| <a name="input_ecs_service_name"></a> [ecs\_service\_name](#input\_ecs\_service\_name) | Name of ECS Service | `string` | n/a | yes |
| <a name="input_ecs_subnets"></a> [ecs\_subnets](#input\_ecs\_subnets) | ECS subnets | `list(string)` | n/a | yes |
| <a name="input_ecs_task_def"></a> [ecs\_task\_def](#input\_ecs\_task\_def) | ECS Task Definition | `string` | n/a | yes |
| <a name="input_load_balancer"></a> [load\_balancer](#input\_load\_balancer) | n/a | <pre>object({<br>    target_group_arn  = string<br>    security_group_id = string<br>    container_name    = string<br>    container_port    = number<br>  })</pre> | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_arn"></a> [service\_arn](#output\_service\_arn) | n/a |
| <a name="output_service_id"></a> [service\_id](#output\_service\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
