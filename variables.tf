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
# variable "AMIS" {
#   type = map(string)
#   default = { # Amazon Linux 2
#     us-east-1 = "ami-02e136e904f3da870"
#     eu-west-1 = "ami-05cd35b907b4ffe77"
#     eu-west-2 = "ami-02f5781cba46a5e8a"
#   }
# }
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


variable "enable_blue_env" {
  description = "Enable blue environment"
  type        = bool
  default     = true
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
}
