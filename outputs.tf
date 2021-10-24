output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_application.vpc_id
}
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc_application.igw_id
}
output "public_subnets_id" {
  description = "List of IDs of public subnets"
  value       = module.vpc_application.public_subnets
}
output "private_subnets_id" {
  description = "List of IDs of private subnets"
  value       = module.vpc_application.private_subnets
}