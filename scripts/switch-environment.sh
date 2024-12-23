#!/bin/bash
# Switch blue green deployment

# Obtener el color activo actual
current_color=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?ExportName==`'${STACK_NAME}-ActiveColor'`].OutputValue' \
    --output text)

# Determinar el nuevo color
new_color=$([ "$current_color" = "blue" ] && echo "green" || echo "blue")

# Actualizar el stack con el nuevo color
aws cloudformation update-stack \
    --stack-name $STACK_NAME \
    --use-previous-template \
    --parameters ParameterKey=ActiveEnvironment,ParameterValue=$new_color \
                ParameterKey=Environment,UsePreviousValue=true \
                ParameterKey=Proj,UsePreviousValue=true \
                ParameterKey=DomainName,UsePreviousValue=true

# Esperar a que se complete la actualización
aws cloudformation wait stack-update-complete --stack-name $STACK_NAME

echo "Switched from $current_color to $new_color environment"