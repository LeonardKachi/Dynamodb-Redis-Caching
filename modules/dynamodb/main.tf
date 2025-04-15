resource "aws_dynamodb_table" "products" {
  name         = "${var.environment}-products"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "productId"

  attribute {
    name = "productId"
    type = "S"
  }

  tags = {
    Name        = "${var.environment}-products-table"
    Environment = var.environment
  }
}
