resource "aws_ecr_repository" "ecr" {
  name                 = var.ecr_name
  image_tag_mutability = var.mutability

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = var.kms_key
  }
}
