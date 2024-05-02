#!/bin/bash

# Definir variáveis
BUCKET_NAME="meu-novo-bucket-$(date +%s)"  # Nome único usando timestamp
REGION="us-east-1"  # Escolha a região conforme necessário
FILE_TO_UPLOAD="aplicacao.py"  # Arquivo para upload

# Criar o bucket no S3
echo "Criando bucket: $BUCKET_NAME"
if [ "$REGION" == "us-east-1" ]; then
    aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION
else
    aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION --create-bucket-configuration LocationConstraint=$REGION
fi

# Verificar se o bucket foi criado com sucesso
if [ $? -eq 0 ]; then
    echo "Bucket criado com sucesso."
    echo "Fazendo upload do arquivo..."
    aws s3 cp $FILE_TO_UPLOAD s3://$BUCKET_NAME/
    
    # Verificar se o upload foi bem-sucedido
    if [ $? -eq 0 ]; then
        echo "Arquivo carregado com sucesso."
    else
        echo "Falha no upload do arquivo."
    fi
else
    echo "Falha na criação do bucket."
fi