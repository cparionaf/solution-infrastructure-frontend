#!/bin/bash
# Script para validar el despliegue

# Obtener el dominio de CloudFront
cloudfront_domain=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?ExportName==`'${STACK_NAME}-CloudFrontDomain'`].OutputValue' \
    --output text)

# Verificar que el sitio responde correctamente
response=$(curl -s -o /dev/null -w "%{http_code}" https://$cloudfront_domain)

if [ $response -eq 200 ]; then
    echo "Deployment validation successful"
    exit 0
else
    echo "Deployment validation failed with status code $response"
    exit 1
fi