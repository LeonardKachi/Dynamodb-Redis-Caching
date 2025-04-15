import os
import json
import boto3
import redis
from aws_lambda_powertools import Metrics, Logger, Tracer

# Initialize utilities
metrics = Metrics()
logger = Logger()
tracer = Tracer()

# Initialize clients
dynamodb = boto3.resource('dynamodb')
products_table = dynamodb.Table(os.environ['DYNAMODB_TABLE'])

# Redis connection
redis_client = redis.Redis(
    host=os.environ['REDIS_HOST'],
    port=6379,
    decode_responses=True
)

@tracer.capture_lambda_handler
def lambda_handler(event, context):
    try:
        product_id = event['pathParameters']['productId']
        cache_key = f"product:{product_id}"
        
        # Try to get from Redis first
        cached_product = redis_client.get(cache_key)
        
        if cached_product:
            logger.info(f"Cache hit for product {product_id}")
            metrics.add_metric(name="CacheHits", unit="Count", value=1)
            return {
                'statusCode': 200,
                'body': cached_product
            }
        
        logger.info(f"Cache miss for product {product_id}")
        metrics.add_metric(name="CacheMisses", unit="Count", value=1)
        
        # Get from DynamoDB
        response = products_table.get_item(Key={'productId': product_id})
        
        if 'Item' not in response:
            return {'statusCode': 404, 'body': json.dumps({'error': 'Product not found'})}
        
        product = response['Item']
        product_json = json.dumps(product)
        
        # Cache with TTL
        redis_client.setex(cache_key, int(os.environ.get('CACHE_TTL', '300')), product_json)
        
        return {
            'statusCode': 200,
            'body': product_json
        }
        
    except Exception as e:
        logger.error(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
