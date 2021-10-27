locals {
  preparedTags = {
    Terraform   = "true"
    Environment = var.environment
    Project     = var.app_tag
    Version     = "0.1.0"
  }
}
data "aws_availability_zones" "available" {
  state = "available"
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
  ami                    = var.AMIS[var.AWS_REGION]
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
module "ec2_application_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name                   = "${var.app_tag}-${var.environment}-app-instance"
  ami                    = var.AMIS[var.AWS_REGION]
  instance_type          = var.instance_type
  key_name               = aws_key_pair.mykeypair.key_name
  monitoring             = true
  vpc_security_group_ids = [module.app_instance_private_sg.security_group_id]
  subnet_id              = module.vpc_application.private_subnets[0]
  user_data              = data.template_cloudinit_config.cloudinit-app-instance.rendered

  tags = merge(local.preparedTags, {
    Role = "app-instance"
  })
}
module "web_server_public_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "~> 4.4"

  name        = "${var.app_tag}-${var.environment}-web-server-public"
  description = "Security group for web-server with HTTP and SSH ports open within VPC"
  vpc_id      = module.vpc_application.vpc_id

  ingress_cidr_blocks = [var.WORKSTATION_CIDR_BLOCK]

  ingress_rules = ["ssh-tcp"]

  tags = merge(local.preparedTags, {
    Role = "web-server"
  })
}
module "app_instance_private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.4"

  name        = "${var.app_tag}-${var.environment}-app-instance-private"
  description = "Security group for private instance app server HTTP 8080 ports open within VPC"
  vpc_id      = module.vpc_application.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-8080-tcp"
      source_security_group_id = module.web_server_public_sg.security_group_id
    },
    {
      rule                     = "ssh-tcp"
      source_security_group_id = module.web_server_public_sg.security_group_id
    }
  ]
  tags = merge(local.preparedTags, {
    Role = "app-instance"
  })
}