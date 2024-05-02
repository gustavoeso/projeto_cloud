import boto3

# Configurar cliente do DynamoDB
dynamodb = boto3.resource('dynamodb', region_name='us-east-1')

# Referência para a tabela
table = dynamodb.Table('Users')

# Criar um usuário
def create_user(user_id, user_name):
    response = table.put_item(
       Item={
            'UserID': user_id,
            'UserName': user_name
        }
    )
    return response

# Listar todos os usuários
def list_users():
    response = table.scan()
    return response['Items']

# Deletar um usuário
def delete_user(user_id):
    response = table.delete_item(
        Key={
            'UserID': user_id
        }
    )
    return response

# # Exemplo de uso
# create_user('001', 'John Doe')
# print(list_users())
# delete_user('001')
