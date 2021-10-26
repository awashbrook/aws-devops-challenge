variable "WORKSTATION_CIDR_BLOCK" {}
variable "AWS_REGION" {
  default = "eu-west-2"
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
variable "AMIS" {
  type = map(string)
  default = { # Amazon Linux 2
    us-east-1 = "ami-02e136e904f3da870"
    eu-west-1 = "ami-05cd35b907b4ffe77"
    eu-west-2 = "ami-02f5781cba46a5e8a"
  }
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

