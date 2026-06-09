output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs (one per AZ) – used by the ALB"
  value       = [for s in aws_subnet.public : s.id]
}

output "private_compute_subnet_ids" {
  description = "List of private compute subnet IDs (one per AZ) – used by ECS/Fargate tasks"
  value       = [for s in aws_subnet.private_compute : s.id]
}

output "private_persistence_subnet_ids" {
  description = "List of private persistence subnet IDs (one per AZ) – used by Aurora"
  value       = [for s in aws_subnet.private_persistence : s.id]
}

output "alb_security_group_id" {
  description = "Security Group ID for the Application Load Balancer"
  value       = aws_security_group.alb.id
}

output "ecs_tasks_security_group_id" {
  description = "Security Group ID for ECS Fargate tasks"
  value       = aws_security_group.ecs_tasks.id
}

output "apigw_vpc_link_security_group_id" {
  description = "Security Group ID for the API Gateway VPC Link"
  value       = aws_security_group.apigw_vpc_link.id
}

output "aurora_security_group_id" {
  description = "Security Group ID for Aurora cluster"
  value       = aws_security_group.aurora.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_ids" {
  description = "Map of AZ → NAT Gateway ID"
  value       = { for az, ngw in aws_nat_gateway.main : az => ngw.id }
}
