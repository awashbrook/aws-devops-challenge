output "az_names" {
  description = "Available Zones in this Region"
  value       = data.aws_availability_zones.available.names
}
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_application.vpc_id
}
output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc_application.igw_id
}
output "public_subnets_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc_application.public_subnets
}
output "public_subnet_cidr_blocks" {
  description = "List of public subnets CIDR blocks"
  value       = module.vpc_application.public_subnets_cidr_blocks
}
output "private_subnets_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc_application.private_subnets
}
output "web_server_public_ip" {
  value = module.ec2_web_server.public_ip
}
output "lb_dns_name" {
  value = aws_lb.app.dns_name
}
