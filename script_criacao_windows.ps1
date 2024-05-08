# Definir variáveis
$BUCKET_NAME="bucket-projeto-gustavo"  # Nome único usando timestamp
$REGION="us-east-1"  # Escolha a região conforme necessário
$FILE_TO_UPLOAD="aplicacao.py"  # Arquivo para upload
$TEMPLATE_FILE="projeto.yaml"  # Caminho para o arquivo de template do CloudFormation
$STACK_NAME="StackGustavo"

# Criar o bucket no S3
Write-Host "Criando bucket: $BUCKET_NAME"
aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION

# Verificar se o bucket foi criado com sucesso
if ($?) {
    Write-Host "Bucket criado com sucesso."
    Write-Host "Fazendo upload do arquivo..."
    aws s3 cp $FILE_TO_UPLOAD s3://$BUCKET_NAME/
    
    # Verificar se o upload foi bem-sucedido
    if ($?) {
        Write-Host "Arquivo carregado com sucesso."

        # Criar a stack no CloudFormation
        Write-Host "Criando a stack do CloudFormation..."
        aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://projeto.yaml --capabilities CAPABILITY_IAM

        if ($?) {
            Write-Host "Stack criada com sucesso."
        } else {
            Write-Host "Falha ao criar a stack."
        }
    } else {
        Write-Host "Falha no upload do arquivo."
    }
} else {
    Write-Host "Falha na criação do bucket."
}
