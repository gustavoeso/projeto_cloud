# Documentação projeto cloud – cloudformation
### Gustavo Eliziario Stevenson de Oliveira

## Descrição do projeto
O projeto de Cloud consiste em construir uma arquitetura de cloud utilizando a plataforma AWS da Amazon. O projeto proposto é criar uma integração entre um Aplication Load Balancer com um número de VPCs (virtual private cloud) que deve ser controlado por um AutoScaling para gerenciar o número de VPCs a serem utilizadas pelo sistema. Com isso as VPCs devem todas conectar em uma única base de dados DynamoDB, e ter uma aplicação que consiga controlar a base de dados.

Na imagem 1 pode-se observar como o projeto está estruturado com o Aplication Load Balancer, as VPCs e a base de dados. No diagrama são destacados 3 VPCs, isso por que o programa feito tem como máquinas desejadas por padrão 3, porém, com o AutoScaling, ele pode variar o número de VPCs de 1 a 5 dependendo do uso da aplicação.

![imagem 1](/imgs/1.png)

E na imagem 2 podemos ver o projeto estruturado por meio da AWS, onde ele mostra tudo que está sendo utilizado e como eles se conectam.

![imagem 2](/imgs/2.png)

## Projeção de custo

Para a projeção de custo, foi utilizado a calculadora de custos da AWS colocando os recursos utilizados para o projeto. Para isso, foi considerado os recursos de CloudFormation, VPC, EC2, S3 (bucket), CloudWatch, Elastic Load Balancing e DynamoDB. Foram utilizados os menores parâmetros possíveis para refletir o mais perto possível do que seria um custo real da aplicação utilizada, mas ainda os recursos mínimos são muito maiores do que realmente é utilizado pelo projeto. Com isso, observando a imagem 3, podemos ver que o custo deu por volta de 107,33 USD, o que equivale a aproximadamente 549,95 BRL.

![imagem 3](/imgs/3.png)

> No repositório no arquivo “My Estimate - AWS Pricing Calculator” está o cálculo de custos por completo com os parâmetros utilizados.

## Passo a passo de como rodar o projeto

Esse projeto foi feito para ser rodado no Linux, existem scripts de criação de Stack para Windows, mas para testar ele utiliza comandos que funcionam apenas em Linux.

### Passo 1 - Baixar AWS CLI
(https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) siga o passo a passo de instalação do CLI para baixar ele, pode ser que esteja faltando um comando para rodar que seria o unzip, para instalar ele, apenas rodar o comando:

```bash
sudo apt install unzip
```

### Passo 2 - fazer o setup do CLI
Para conseguir conectar o CLI com a sua conta da AWS, rode o comando:

```bash
aws configure
```

e com isso colocar o Access Key ID, o Secret access key e a região que está a AWS (Ex. us-east-1). Essas informações podem ser obtidas através o AWS console.

### Passo 3 - Clonar o repositório
Assim que o AWS CLI estiver configurado corretamente, pode clonar o repositório do projeto
(https://github.com/gustavoeso/projeto_cloud.git)
utilizando o comando:

```bash
git clone https://github.com/gustavoeso/projeto_cloud.git
```

Se você não tem git instalado, rode o comando:

```bash
sudo apt install git-all
```

> Vale notar que pode existir a possibilidade de colocar seu login e senha, a senha tem que ser um token gerado pelo GitHub.

### Passo 4 - Rodar o Script de criação do projeto
Agora que está tudo preparado, o projeto já pode ser executado, portanto entre na pasta do projeto usando o comando

```bash
cd <path para o arquivo>
```

Assim que estiver dentro da pasta do projeto, existem 2 scripts, um de criação e um de deletar, vamos começar com o script de criação. O arquivo do script é o:

```
script_criacao_linux.sh
```

onde ele é um arquivo '.sh'. Para utilizar ele, é preciso fazer ele ser um executável, para isso, rode o comando:

```bash
chmod +x script_criacao_linux.sh
```

Com isso o script virou executável, agora é só rodar o comando:

```bash
./script_criacao_linux.sh
```

### Passo 5 - Pegar o DNS do ALB (Aplication Load Balancer)
Após aguardar para que a Stack seja devidamente criada, é possível pegar o DNS gerado pelo ALB. Para isso rode o comando:

```bash
aws cloudformation describe-stacks --stack-name StackGustavo --query 'Stacks[0].Outputs[?OutputKey==`LoadBalancerDNS`].OutputValue' --output text
```
> exemplo de DNS seria: StackG-AppLo-U4ar63893NSl-956522211.us-east-1.elb.amazonaws.com

Com o DNS, agora é possível testar a aplicação do projeto.

### Passo 6 - Testar a aplicação
Para testar a aplicação, recomendo ja entrar na rota de listar usuários pelo seu browser:

```
<DNS-DO-ALB>/list_users
```

onde ```<DNS-DO-ALB>``` deve ser substituído pelo DNS que foi obtido no passo anterior, e agora pode começar testando com a criação de um usuário. Para isso, rode o seguinte comando:

```bash
curl -X POST http://<DNS-DO-ALB>/create_user -H "Content-Type: application/json" -d '{"user_id": "1", "user_name": "Exemplo"}'
```

> lembrando de sibstiuir ```<DNS-DO-ALB>``` pelo dns obtido no ultimo comando

Com isso, um usuário com id = 1 e user_name = Exemplo será criado, portanto se recarregar a página de listar usuário, pode-se observar que um usuário foi devidamente criado. Agora para testar se é possível deletar usuário, rode o seguinte comando:

```bash
curl -X DELETE "http://<DNS-DO-ALB>/delete_user?user_id=1"
```

Isso deve deletar o usuário, portanto ao recarregar a página de listar usuário, ele agora deve estar vazio. Lembrando que todos os parâmetros estão pré-definidos, como id e user-name, mas isso pode ser modificado para testar com outros valores.

### Passo 7 - Deletar a Stack
Agora que o projeto foi testado e foi possível ver que está tudo funcionando, podemos deletar o projeto. Para isso, basta utilizar o script de deletar o projeto
```
script_deletar_linux.sh
```

para isso, como no script de criação, precisamos transformar ele em um executável, portanto primeiro rodar o comando:

```bash
chmod +x script_deletar_linux.sh
```

e logo depois disso, executar o script

```bash
./script_deletar_linux.sh
```

Caso seja necessário para fazer um update do YAML do projeto, apenas rode o comando:
```bash
aws cloudformation update-stack --stack-name <Nome-da-sua-stack> --template-body file://projeto.yaml --capabilities CAPABILITY_IAM
```

Onde ```<Nome-da-sua-stack>``` é o nome da stack criada.