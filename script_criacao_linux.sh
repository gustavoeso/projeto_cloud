#!/bin/bash

# Definir variáveis
BUCKET_NAME="bucket-projeto-gustavo"  # Nome único usando timestamp
REGION="us-east-1"  # Escolha a região conforme necessário
FILE_TO_UPLOAD="aplicacao.py"  # Arquivo para upload
TEMPLATE_FILE="projeto.yaml"  # Caminho para o arquivo de template do CloudFormation
STACK_NAME="StackGustavo"

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

        # Criar a stack no CloudFormation
        echo "Criando a stack do CloudFormation..."
        aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://projeto.yaml --capabilities CAPABILITY_IAM

        if [ $? -eq 0 ]; then
            echo "Stack criada com sucesso."
        else
            echo "Falha ao criar a stack."
        fi
    else
        echo "Falha no upload do arquivo."
    fi
else
    echo "Falha na criação do bucket."
fi
