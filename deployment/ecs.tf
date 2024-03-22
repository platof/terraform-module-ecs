module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
  version = "5.9.3"

  cluster_name = "ecs-cluster"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "node-logs"
      }
    }
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  services = {
    ecs-backend = {
      cpu    = 1024
      memory = 2048

      # Container definition(s)
      container_definitions = {

        ecs-sample = {
          cpu       = 512
          memory    = 1024
          essential = true
          image     = "253449359474.dkr.ecr.us-east-1.amazonaws.com/backend-repo:latest"
          port_mappings = [
            {
              name          = "ecs-sample"
              containerPort = 8080
              protocol      = "tcp"
            }
          ]

          # Example image used requires access to write to root filesystem
          readonly_root_filesystem = false

          enable_cloudwatch_logging = true
          
          memory_reservation = 100
        }
      }

      load_balancer = {
        service = {
          target_group_arn = module.alb.target_groups["ex_ecs"].arn
          container_name   = "ecs-sample"
          container_port   = 8080
        }
      }

      subnet_ids = module.vpc.private_subnets

      security_group_rules = {
        alb_ingress_3000 = {
          type                     = "ingress"
          from_port                = 8080
          to_port                  = 8080
          protocol                 = "tcp"
          description              = "Service port"
          source_security_group_id = module.alb.security_group_id
        }

        egress_all = {
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }

  tags = {
    Environment = "Development"
    Project     = "ecs"
  }
}