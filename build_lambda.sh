#!/bin/bash

LAMBDA_DIR="lambda/get_product"
ZIP_FILE="lambda.zip"

cd $LAMBDA_DIR

# Install dependencies
pip install -r requirements.txt -t .

# Create zip (exclude hidden files)
zip -r ../$ZIP_FILE . -x ".*" -x "__MACOSX"

# Clean up installed packages
rm -rf bin certifi* charset_normalizer* idna* requests* urllib3* 
rm -rf __pycache__

echo "Lambda package created at $LAMBDA_DIR/../$ZIP_FILE"
