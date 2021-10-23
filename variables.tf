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
variable "workstation_cidr" {}
