locals {
  container_definitions = [
    {
      name                   = var.service_name
      image                  = var.container_image
      cpu                    = 10
      memory                 = 512
      essential              = true
      readonlyRootFilesystem = true
      portMappings = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.app
          awslogs-region        = "eu-west-2"
          awslogs-create-group  = "true"
          awslogs-stream-prefix = var.app
        }
      }
    }
  ]
  lb = {
    name = var.app

  }

}

module "network" {
  source  = "./modules/vpc"
  egress  = var.egress
  ingress = var.ingress
  region  = var.deploy_region
  providers = {
    aws = aws.deployment
  }
}

/*module "squid_ecr" {
  source   = "./modules/ecr"
  ecr_name = "squid"
  kms_key  = aws_kms_key.key.arn
  providers = {
    aws = aws.deployment
  }
}


resource "aws_kms_key" "key" {
  # checkov:skip=CKV2_AWS_64: "Ensure KMS key Policy is defined"
  description             = "ECR Key"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  provider                = aws.deployment
}*/

data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "execution" {
  name               = "${var.project}-${var.environment}-execution-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
  provider           = aws.deployment
}

resource "aws_iam_role_policy_attachment" "execution_policy" {
  provider   = aws.deployment
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_task_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

  }
}

resource "aws_iam_role" "task" {
  name               = "${var.project}-${var.environment}-task-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy.json
  provider           = aws.deployment
}

module "task" {
  source                = "./modules/ecs-task"
  task_family           = var.app
  task_role_arn         = aws_iam_role.task.arn
  execution_role_arn    = aws_iam_role.execution.arn
  container_definitions = local.container_definitions
  providers = {
    aws = aws.deployment
  }
}

resource "aws_kms_key" "ecs_key" {
  description             = "ECS Key"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  provider                = aws.deployment
}

resource "aws_kms_key_policy" "ecs_key_policy" {
  provider = aws.deployment
  key_id   = aws_kms_key.ecs_key.id
  policy = jsonencode({
    Id = "logs"
    Statement = [
      {
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ]
        Effect = "Allow"
        Principal = {
          "Service" : "logs.amazonaws.com"
        }
        Resource = "*"
        Sid      = "Enable CloudWatch Log Encryption"
      },
      {
        Sid    = "Enable IAM User Permissions",
        Effect = "Allow",
        Principal = {
          "AWS" : "arn:aws:iam::680805529666:root"
        },
        Action   = "kms:*",
        Resource = "*"
      }
    ]
    Version = "2012-10-17"
  })
}

module "cluster" {
  source                               = "./modules/ecs-cluster"
  cluster_name                         = "proxy-services"
  cluster_log_group_name               = "/proxy-services"
  cluster_execution_encryption_key_arn = aws_kms_key.ecs_key.arn
  providers = {
    aws = aws.deployment
  }
}

module "lb" {
  source       = "./modules/nlb"
  vpc_id       = module.network.vpc_id
  subnet_ids   = module.network.access_subnet_ids
  lb           = local.lb
  ingress_ips  = split(",", var.ingress_ips)
  ingress_port = 80
  internal     = true
  target_group = {
    name = var.app
    port = 80
  }
  providers = {
    aws = aws.deployment
  }
}

module "service" {
  source           = "./modules/ecs-service"
  ecs_service_name = var.app
  vpc_id           = module.network.vpc_id
  ecs_cluster_id   = module.cluster.cluster_arn
  ecs_task_def     = module.task.task_arn
  ecs_subnets      = module.network.application_subnet_ids
  load_balancer = {
    container_name    = var.app
    container_port    = var.app_port
    target_group_arn  = module.lb.target_group_arn
    security_group_id = module.lb.security_group_id

  }
  providers = {
    aws = aws.deployment
  }
}

module "proxy_address" {
  source  = "./modules/route53"
  name    = "${var.environment}proxy"
  zone    = var.zone
  address = module.lb.lb_address

  providers = {
    aws = aws.dns
  }
}

module "reminder" {
  source     = "./modules/sns"
  name       = "${var.environment}proxy"
  sms_number = var.sms_number
}
