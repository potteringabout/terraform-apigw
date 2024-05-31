# mod1

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
| [aws_ecr_repository.ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ecr_name"></a> [ecr\_name](#input\_ecr\_name) | Name of ECR | `string` | n/a | yes |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | KMS Key ARN for ECR encryption | `string` | n/a | yes |
| <a name="input_mutability"></a> [mutability](#input\_mutability) | Immutable image tags | `string` | `"IMMUTABLE"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
