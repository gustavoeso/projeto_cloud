# Definir variáveis
$BUCKET_NAME="meu-novo-bucket-$([DateTime]::Now.ToString("yyyyMMddHHmmss"))" # Com data e hora para evitar conflitos
$REGION="us-east-1"  # Substitua conforme necessário
$FILE_TO_UPLOAD="aplicacao.py"

# Criar o bucket no S3
Write-Host "Criando bucket: $BUCKET_NAME"
if ($REGION -eq "us-east-1") {
    aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION
} else {
    aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION --create-bucket-configuration LocationConstraint=$REGION
}

# Verificar se o bucket foi criado e fazer upload do arquivo
if ($LASTEXITCODE -eq 0) {
    Write-Host "Bucket criado com sucesso."
    Write-Host "Fazendo upload do arquivo..."
    aws s3 cp $FILE_TO_UPLOAD s3://$BUCKET_NAME/

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Arquivo carregado com sucesso."
    } else {
        Write-Host "Falha no upload do arquivo."
    }
} else {
    Write-Host "Falha na criação do bucket."
}
