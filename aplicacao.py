from flask import Flask, request, jsonify
import boto3
import logging

app = Flask(__name__)

# Configurar cliente do DynamoDB
dynamodb = boto3.resource('dynamodb', region_name='us-east-1')

# Referência para a tabela
table = dynamodb.Table('Users')

# Configurar logging
logging.basicConfig(level=logging.INFO)

@app.route('/')
def home():
    return "Health Check OK", 200

@app.route('/create_user', methods=['POST'])
def create_user():
    try:
        user_id = request.json.get('user_id')
        user_name = request.json.get('user_name')
        response = table.put_item(
            Item={
                'UserID': user_id,
                'UserName': user_name
            }
        )
        app.logger.info(f"User created: {user_id}, {user_name}")
        return jsonify(response), 201
    except Exception as e:
        app.logger.error(f"Error creating user: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/list_users', methods=['GET'])
def list_users():
    try:
        response = table.scan()
        app.logger.info("Users listed")
        return jsonify(response['Items']), 200
    except Exception as e:
        app.logger.error(f"Error listing users: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/delete_user', methods=['DELETE'])
def delete_user():
    try:
        user_id = request.args.get('user_id')
        response = table.delete_item(
            Key={
                'UserID': user_id
            }
        )
        app.logger.info(f"User deleted: {user_id}")
        return jsonify(response), 200
    except Exception as e:
        app.logger.error(f"Error deleting user: {e}")
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
