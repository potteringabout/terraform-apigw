# Terrform project template

Sample project for deploying AWS infrastructure using Terraform

https://github.com/Allwyn-UK/plat-tf-template.git

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_aws.deployment"></a> [aws.deployment](#provider\_aws.deployment) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_network"></a> [network](#module\_network) | ./modules/vpc | n/a |
| <a name="module_proxy_address"></a> [proxy\_address](#module\_proxy\_address) | ./modules/route53 | n/a |
| <a name="module_reminder"></a> [reminder](#module\_reminder) | ./modules/sns | n/a |
| <a name="module_squid_cluster"></a> [squid\_cluster](#module\_squid\_cluster) | ./modules/ecs-cluster | n/a |
| <a name="module_squid_lb"></a> [squid\_lb](#module\_squid\_lb) | ./modules/nlb | n/a |
| <a name="module_squid_service"></a> [squid\_service](#module\_squid\_service) | ./modules/ecs-service | n/a |
| <a name="module_squid_task"></a> [squid\_task](#module\_squid\_task) | ./modules/ecs-task | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.squid_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.squid_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.squid_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.ecs_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.ecs_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_iam_policy_document.ecs_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | Account name abbreviation | `string` | `"prod"` | no |
| <a name="input_account_full"></a> [account\_full](#input\_account\_full) | Account name | `string` | `"Production Account"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"eu-west-2"` | no |
| <a name="input_costcentre"></a> [costcentre](#input\_costcentre) | The cost centre to charge the asset to | `string` | `"123"` | no |
| <a name="input_deploy_region"></a> [deploy\_region](#input\_deploy\_region) | n/a | `string` | n/a | yes |
| <a name="input_deployment_mode"></a> [deployment\_mode](#input\_deployment\_mode) | How the resource was deployed | `string` | `"auto"` | no |
| <a name="input_deployment_repo"></a> [deployment\_repo](#input\_deployment\_repo) | The URL of the deployment repo | `string` | n/a | yes |
| <a name="input_deployment_role_arn"></a> [deployment\_role\_arn](#input\_deployment\_role\_arn) | The ARN of role to be assumed for deployment tasks | `string` | `""` | no |
| <a name="input_dns_role_arn"></a> [dns\_role\_arn](#input\_dns\_role\_arn) | The ARN of role to be assumed for DNS updates | `string` | `""` | no |
| <a name="input_egress"></a> [egress](#input\_egress) | n/a | `bool` | `true` | no |
| <a name="input_email"></a> [email](#input\_email) | Email contact for the asset owner | `string` | `"platformengineering@allwyn.co.uk"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name abbreviation in lower case | `string` | `"prod"` | no |
| <a name="input_environment_full"></a> [environment\_full](#input\_environment\_full) | The environment name in full | `string` | `"Production environment for shared services"` | no |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | n/a | `bool` | `true` | no |
| <a name="input_ingress_ips"></a> [ingress\_ips](#input\_ingress\_ips) | n/a | `string` | `"0.0.0.0/32"` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | The individual or team owner of the asset | `string` | `"Platform Engineering"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project abbreviation in lower case | `string` | `"ss"` | no |
| <a name="input_project_full"></a> [project\_full](#input\_project\_full) | The project name in full | `string` | `"Shared Services"` | no |
| <a name="input_sms_number"></a> [sms\_number](#input\_sms\_number) | n/a | `string` | n/a | yes |
| <a name="input_squid_container_image"></a> [squid\_container\_image](#input\_squid\_container\_image) | The Squid container to use | `string` | n/a | yes |
| <a name="input_squid_service_name"></a> [squid\_service\_name](#input\_squid\_service\_name) | The Squid service name | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
