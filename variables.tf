variable "workstation_cidr_block" {}
variable "AWS_REGION" {
  default = "eu-west-1"
}
variable "app_tag" {
  default = "devops"
}
variable "environment" {
  default = "dev"
}
variable "vpc_cidr_application" {
  default = "10.0.0.0/16"
}
variable "vpc_cidr_bastion" {
  default = "172.168.0.0/16"
}
# Free Tier Eligible 
variable "instance_type" {
  # default = "t2.micro"
  default = "t3.nano"
}
variable "PATH_TO_PRIVATE_KEY" {
  default = "~/.ssh/mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "~/.ssh/mykey.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ec2-user"
}

# Feature Toggles for Blue/Green Envionments
variable "enable_blue_env" {
  description = "Enable blue environment"
  type        = bool
  default     = false
}

variable "blue_instance_count" {
  description = "Number of instances in blue environment"
  type        = number
  default     = 2
}

variable "enable_green_env" {
  description = "Enable green environment"
  type        = bool
  default     = true
}

variable "green_instance_count" {
  description = "Number of instances in green environment"
  type        = number
  default     = 2
}

# Feature Toggles for Blue/Green or Canary Releases - Traffic Distribution

locals {
  traffic_dist_map = {
    blue = {
      blue  = 100
      green = 0
    }
    blue-90 = {
      blue  = 90
      green = 10
    }
    split = {
      blue  = 50
      green = 50
    }
    green-90 = {
      blue  = 10
      green = 90
    }
    green = {
      blue  = 0
      green = 100
    }
  }
}

variable "traffic_distribution" {
  description = "Levels of traffic distribution"
  type        = string
  default = "green"
}
