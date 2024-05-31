locals {
  container_definitions = [
    {
      name                   = var.squid_service_name
      image                  = var.squid_container_image
      cpu                    = 10
      memory                 = 512
      essential              = true
      readonlyRootFilesystem = true
      portMappings = [
        {
          containerPort = 3128
          hostPort      = 3128
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "squid"
          awslogs-region        = "eu-west-2"
          awslogs-create-group  = "true"
          awslogs-stream-prefix = "proxy"
        }
      }
      healthCheck = {
        command     = ["CMD-SHELL", "squidclient -h localhost cache_object://localhost/counters || exit 1"]
        interval    = 30
        timeout     = 5
        startPeriod = 10
        retries     = 3
      }

    }
  ]
  lb = {
    name = "squid"

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

resource "aws_iam_role" "squid_execution" {
  name               = "squid-execution-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
  provider           = aws.deployment
}

resource "aws_iam_role_policy_attachment" "squid_execution_policy" {
  provider   = aws.deployment
  role       = aws_iam_role.squid_execution.name
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

resource "aws_iam_role" "squid_task" {
  name               = "squid-task-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy.json
  provider           = aws.deployment
}

module "squid_task" {
  source                = "./modules/ecs-task"
  task_family           = "squid"
  task_role_arn         = aws_iam_role.squid_task.arn
  execution_role_arn    = aws_iam_role.squid_execution.arn
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

module "squid_cluster" {
  source                               = "./modules/ecs-cluster"
  cluster_name                         = "proxy-services"
  cluster_log_group_name               = "/proxy-services"
  cluster_execution_encryption_key_arn = aws_kms_key.ecs_key.arn
  providers = {
    aws = aws.deployment
  }
}

/*module "squid_lb" {
  source     = "./modules/alb"
  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.access_subnet_ids
  lb        = local.lb
  ingress_ips = split(",", var.ingress_ips)

  target_group = {
    name = "squid"
    port = 3128
  }
}*/

module "squid_lb" {
  source      = "./modules/nlb"
  vpc_id      = module.network.vpc_id
  subnet_ids  = module.network.access_subnet_ids
  lb          = local.lb
  ingress_ips = split(",", var.ingress_ips)
  target_group = {
    name = "squid"
    port = 3128
  }
  providers = {
    aws = aws.deployment
  }
}

module "squid_service" {
  source           = "./modules/ecs-service"
  ecs_service_name = "squid"
  vpc_id           = module.network.vpc_id
  ecs_cluster_id   = module.squid_cluster.cluster_arn
  ecs_task_def     = module.squid_task.task_arn
  ecs_subnets      = module.network.application_subnet_ids
  load_balancer = {
    container_name    = "squid"
    container_port    = 3128
    target_group_arn  = module.squid_lb.target_group_arn
    security_group_id = module.squid_lb.security_group_id

  }
  providers = {
    aws = aws.deployment
  }
}

module "proxy_address" {
  source  = "./modules/route53"
  name    = "${var.environment}proxy"
  zone    = var.zone
  address = module.squid_lb.lb_address

  providers = {
    aws = aws.dns
  }
}

module "reminder" {
  source     = "./modules/sns"
  name       = "${var.environment}proxy"
  sms_number = var.sms_number
}
