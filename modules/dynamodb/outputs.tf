output "products_table_name" {
  description = "DynamoDB table name"
  value       = aws_dynamodb_table.products.name
}

output "products_table_arn" {
  description = "DynamoDB table ARN"
  value       = aws_dynamodb_table.products.arn
}
