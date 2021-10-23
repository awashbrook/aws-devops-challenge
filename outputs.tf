output "vpc_application_id" {
  value = module.vpc_application.vpc_id
}
output "internet_gateway_id" {
  value = module.vpc_application.public_internet_gateway_route_id
}
output "public_subnets_id" {
  value = module.vpc_application.public_subnets
}
output "private_subnets_id" {
  value = module.vpc_application.private_subnets
}