resource "aws_cloudwatch_log_group" "log" {
  name              = var.cluster_log_group_name
  retention_in_days = 365
  kms_key_id        = var.cluster_execution_encryption_key_arn
}

resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name

  configuration {
    execute_command_configuration {
      kms_key_id = var.cluster_execution_encryption_key_arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.log.name
      }
    }
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
