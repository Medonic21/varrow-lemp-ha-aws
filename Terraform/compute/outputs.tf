# VPC and Subnet Outputs (from networking module)
output "vpc_id" {
  value       = local.vpc_id
  description = "ID of the VPC"
}

output "public_subnet_1_id" {
  value       = local.public_subnet_1_id
  description = "ID of Public Subnet 1"
}

output "public_subnet_2_id" {
  value       = local.public_subnet_2_id
  description = "ID of Public Subnet 2"
}

output "private_subnet_1_id" {
  value       = local.private_subnet_1_id
  description = "ID of Private Subnet 1"
}

output "private_subnet_2_id" {
  value       = local.private_subnet_2_id
  description = "ID of Private Subnet 2"
}

#################################################################################
# Security Group Outputs
#################################################################################

output "alb_security_group_id" {
  value       = aws_security_group.alb_sg.id
  description = "ID of the ALB security group"
}

output "alb_security_group_name" {
  value       = aws_security_group.alb_sg.name
  description = "Name of the ALB security group"
}

output "ec2_security_group_id" {
  value       = aws_security_group.ec2_sg.id
  description = "ID of the EC2 security group"
}

output "ec2_security_group_name" {
  value       = aws_security_group.ec2_sg.name
  description = "Name of the EC2 security group"
}

output "rds_security_group_id" {
  value       = aws_security_group.rds_sg.id
  description = "ID of the RDS security group"
}

output "rds_security_group_name" {
  value       = aws_security_group.rds_sg.name
  description = "Name of the RDS security group"
}

#################################################################################
# EC2 Instance Outputs
#################################################################################

output "instance_ids" {
  value       = aws_instance.compute_instances[*].id
  description = "List of EC2 instance IDs"
}

output "instance_private_ips" {
  value       = aws_instance.compute_instances[*].private_ip
  description = "List of private IP addresses"
}

output "instance_public_ips" {
  value       = aws_instance.compute_instances[*].public_ip
  description = "List of public IP addresses (if applicable)"
}

output "instance_availability_zones" {
  value       = aws_instance.compute_instances[*].availability_zone
  description = "Availability zones of the instances"
}

output "instances_info" {
  value = [
    for instance in aws_instance.compute_instances : {
      id         = instance.id
      private_ip = instance.private_ip
      public_ip  = instance.public_ip
      az         = instance.availability_zone
      subnet_id  = instance.subnet_id
    }
  ]
  description = "Detailed information about EC2 instances"
}
