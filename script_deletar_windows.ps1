# Definir variáveis
$BUCKET_NAME="bucket-projeto-gustavo"  # Substitua pelo nome do bucket
$STACK_NAME="StackGustavo"    # Substitua pelo nome da stack
$REGION="us-east-1"              # Escolha a região conforme necessário

# Deletar o bucket e seu conteúdo
Write-Host "Deletando o bucket: $BUCKET_NAME e todo o seu conteúdo..."
aws s3 rb s3://$BUCKET_NAME --force

# Verificar se o bucket foi deletado com sucesso
if ($?) {
    Write-Host "Bucket deletado com sucesso."

    # Deletar a stack no CloudFormation
    Write-Host "Deletando a stack do CloudFormation..."
    aws cloudformation delete-stack --stack-name $STACK_NAME --region $REGION

    if ($?) {
        Write-Host "Stack deletada com sucesso."
    } else {
        Write-Host "Falha ao deletar a stack."
    }
} else {
    Write-Host "Falha ao deletar o bucket."
}
