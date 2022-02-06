locals {
  preparedTags = {
    Terraform   = "true"
    Environment = var.environment
    Project     = var.app_tag
    Version     = "0.1.0"
  }
}
module "vpc_application" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>3.10"

  name = "${var.app_tag}-${var.environment}-vpc"
  cidr = var.vpc_cidr_application

  azs             = slice(data.aws_availability_zones.available.names, 0, 3) # First 3 Available AZs in Region 
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = merge(local.preparedTags, {
    Role = "app-vpc"
  })
}
module "ec2_web_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name                   = "${var.app_tag}-${var.environment}-web-server"
  ami                    = data.aws_ami.amazon_linux_2.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.mykeypair.key_name
  monitoring             = true
  vpc_security_group_ids = [module.web_server_public_sg.security_group_id]
  subnet_id              = module.vpc_application.public_subnets[0]
  user_data              = data.template_cloudinit_config.cloudinit-web-server.rendered

  tags = merge(local.preparedTags, {
    Role = "web-server"
  })
}
module "web_server_public_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "~> 4.4"

  name        = "${var.app_tag}-${var.environment}-web-server-public"
  description = "Security group for web-server with HTTP and SSH ports open within VPC"
  vpc_id      = module.vpc_application.vpc_id

  ingress_cidr_blocks = module.vpc_application.public_subnets_cidr_blocks

  ingress_rules = ["ssh-tcp"]

  tags = merge(local.preparedTags, {
    Role = "web-server"
  })
}

module "lb_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "3.17.0"

  name        = "lb-sg"
  description = "Security group for load balancer with HTTP ports open within VPC"
  vpc_id      = module.vpc_application.vpc_id

  # TBD ingress_cidr_blocks = [var.workstation_cidr_block]
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


resource "random_pet" "app" {
  length    = 2
  separator = "-"
}

resource "aws_lb" "app" {
  name               = "main-app-${random_pet.app.id}-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc_application.public_subnets
  security_groups    = [module.lb_security_group.this_security_group_id]
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.blue.arn
        weight = lookup(local.traffic_dist_map[var.traffic_distribution], "blue", 100)
      }
      target_group {
        arn    = aws_lb_target_group.green.arn
        weight = lookup(local.traffic_dist_map[var.traffic_distribution], "green", 0)
      }
      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }
}
