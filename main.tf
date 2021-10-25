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

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Project     = var.app_tag
    Version     = "0.1.0"
    Role        = "app-vpc"
  }
}

module "ec2-application-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "${var.app_tag}-${var.environment}-app-instance"

  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  # the public SSH key
  key_name               = aws_key_pair.mykeypair.key_name
  monitoring             = true
  vpc_security_group_ids = ["sg-12345678"] # # TODO Default SG?
  subnet_id              = module.vpc_application.private_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Project     = var.app_tag
    Version     = "0.1.0"
    Role        = "app-instance"
  }
}

