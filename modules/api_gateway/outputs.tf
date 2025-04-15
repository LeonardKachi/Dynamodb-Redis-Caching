output "api_url" {
  description = "API Gateway endpoint URL"
  value       = "${aws_api_gateway_deployment.deployment.invoke_url}/product"
}

output "api_id" {
  description = "API Gateway ID"
  value       = aws_api_gateway_rest_api.api.id
}
