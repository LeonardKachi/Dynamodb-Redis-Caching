terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "./modules/networking"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "elasticache" {
  source     = "./modules/elasticache"
  vpc_id     = module.networking.vpc_id
  subnet_ids = module.networking.private_subnet_ids
}

module "lambda" {
  source               = "./modules/lambda"
  vpc_id              = module.networking.vpc_id
  subnet_ids          = module.networking.private_subnet_ids
  dynamodb_table_name = module.dynamodb.products_table_name
  redis_endpoint      = module.elasticache.redis_endpoint
  security_group_ids  = [module.networking.lambda_sg_id]
}
