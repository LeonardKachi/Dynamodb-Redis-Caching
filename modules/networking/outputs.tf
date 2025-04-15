output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "lambda_sg_id" {
  description = "Lambda security group ID"
  value       = aws_security_group.lambda.id
}
