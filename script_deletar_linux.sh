#!/bin/bash

# Definir variáveis
BUCKET_NAME="bucket-projeto-gustavo"  # Substitua pelo nome do bucket
STACK_NAME="StackGustavo"    # Substitua pelo nome da stack
REGION="us-east-1"              # Escolha a região conforme necessário

# Deletar o bucket e seu conteúdo
echo "Deletando o bucket: $BUCKET_NAME e todo o seu conteúdo..."
aws s3 rb s3://$BUCKET_NAME --force

# Verificar se o bucket foi deletado com sucesso
if [ $? -eq 0 ]; then
    echo "Bucket deletado com sucesso."

    # Deletar a stack no CloudFormation
    echo "Deletando a stack do CloudFormation..."
    aws cloudformation delete-stack --stack-name $STACK_NAME --region $REGION

    if [ $? -eq 0 ]; then
        echo "Stack deletada com sucesso."
    else
        echo "Falha ao deletar a stack."
    fi
else
    echo "Falha ao deletar o bucket."
fi
