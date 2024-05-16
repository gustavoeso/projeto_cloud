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

> No repositório no arquivo “My Estimate - AWS Pricing Calculator” está o cálculo de custos por completo com os parâmetros utilizados. Segue o link:
 [análise de custos](https://github.com/gustavoeso/projeto_cloud/blob/main/My%20Estimate%20-%20AWS%20Pricing%20Calculator.pdf)

## Passo a passo de como rodar o projeto

Esse projeto foi feito para ser rodado no Linux, existem scripts de criação de Stack para Windows, mas para testar ele utiliza comandos que funcionam apenas em Linux.

### Passo 1 - Baixar AWS CLI
(https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) siga o passo a passo de instalação do CLI para baixar ele, pode ser que esteja faltando um comando para rodar que seria o unzip, para instalar ele, apenas rodar o comando:

```bash
sudo apt install unzip
```

Com o unzip instalado, rode o seguinte comando para baixar o AWS CLI:

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
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
aws cloudformation update-stack --stack-name StackGustavo --template-body file://projeto.yaml --capabilities CAPABILITY_IAM
```

> Note que o projeto está rodando com o nome da stack sendo StackGustavo, isso pode mudar, portanto ao mudar o nome da stack, esse nome teria que mudar em todos os comandos que ele é utilizado para o nome desejado. E para funcionar, também teria que mudar o nome da stack no script de criação e deletar, onde deve ser modificado na variável ```STACK_NAME```. O mesmo pode ser feito com o bucket, modificando nos comandos necessários e na variável ```BUCKET_NAME``` dos scripts.

## Descrição dos recursos utilizados para o projeto

#### **SecurityGroup**
- **Descrição**: Define um grupo de segurança para controlar o tráfego de entrada para as instâncias EC2 na VPC.
- **Propriedades**:
  - **GroupDescription**: Descrição textual do grupo de segurança.
  - **VpcId**: Associa o grupo de segurança à VPC `gustavoVPC`.
  - **SecurityGroupIngress**: Regras de entrada para permitir tráfego HTTP na porta 80 e SSH na porta 22 de qualquer IP.
  - **Tags**: Etiqueta para identificação do grupo de segurança.

#### **gustavoVPC**
- **Descrição**: Cria uma VPC para isolar logicamente a parte da nuvem AWS que você está usando.
- **Propriedades**:
  - **CidrBlock**: Bloco de endereços IP da VPC.
  - **EnableDnsSupport**: Ativa o suporte DNS dentro da VPC.
  - **EnableDnsHostnames**: Ativa a atribuição de DNS hostname para instâncias na VPC.
  - **Tags**: Etiqueta para identificação da VPC.

#### **PublicSubnet1** & **PublicSubnet2**
- **Descrição**: Sub-redes públicas que permitem comunicação direta com a internet.
- **Propriedades**:
  - **VpcId**: Associação com a VPC `gustavoVPC`.
  - **CidrBlock**: Bloco de endereços específico para cada sub-rede.
  - **AvailabilityZone**: Zona de disponibilidade da sub-rede.
  - **MapPublicIpOnLaunch**: Ativa a atribuição automática de IP público para instâncias lançadas nesta sub-rede.
  - **Tags**: Etiqueta para identificação das sub-redes.

#### **S3AccessRole**
- **Descrição**: Define uma role IAM que permite às instâncias EC2 acessar recursos no S3 e DynamoDB.
- **Propriedades**:
  - **AssumeRolePolicyDocument**: Política que define quem pode assumir a role.
  - **Policies**: Políticas anexadas à role que especificam as permissões.

#### **EC2InstanceProfile**
- **Descrição**: Perfil de instância que associa a role IAM `S3AccessRole` às instâncias EC2.
- **Propriedades**:
  - **Roles**: Lista de roles associadas ao perfil.

#### **AppLaunchConfiguration**
- **Descrição**: Configuração de lançamento para Auto Scaling que especifica AMI, tipo de instância, e grupo de segurança.
- **Propriedades**:
  - **ImageId**, **InstanceType**, **SecurityGroups**, **IamInstanceProfile**: Especificações da instância.
  - **UserData**: Script para configuração inicial da instância, como instalação de software.

#### **AppAutoScalingGroup**
- **Descrição**: Grupo de Auto Scaling que gerencia a escalabilidade das instâncias com base na configuração de lançamento. Foram utilizadas minimo de 1, maximo de 5 e 3 de desejadas instancias para o projeto, mas da forma que o Auto Scaling está configurado, ele faz com que sempre trabalhe com o mínimo possível para melhor gerenciamento de gastos.
- **Propriedades**:
  - **LaunchConfigurationName**: Nome da configuração de lançamento.
  - **VPCZoneIdentifier**: Identificadores de sub-rede para lançamento das instâncias.
  - **MetricsCollection**: Coleta de métricas de desempenho.
  - **TargetGroupARNs**: ARNs dos grupos alvo para balanceamento de carga.

#### **CPUUtilizationAlarmHigh**, **ScaleOutPolicy**, **ScaleInPolicy**
- **Descrição**: Alarmes e políticas de escalabilidade para monitorar e ajustar o tamanho do grupo de Auto Scaling baseado na utilização de CPU.
- **Propriedades**:
  - **MetricName**, **Threshold**, **ComparisonOperator**, **ScalingAdjustment**: Configurações para monitoramento e resposta automática a mudanças na utilização da CPU.

#### **AppLoadBalancer**, **AppTargetGroup**, **Listener**
- **Descrição**: Configuração do Application Load Balancer, grupo alvo e ouvinte para gerenciar o tráfego de entrada.
- **Propriedades**:
  - **Type**, **Subnets**, **SecurityGroups**: Especificações do ALB.
  - **Protocol**, **Port**, **HealthCheckConfigurations**: Definições para o manejo do tráfego e verificação de saúde das instâncias.

#### **DynamoDBTable**
- **Descrição**: Tabela DynamoDB para armazenamento de dados.
- **Propriedades**:
  - **TableName**, **AttributeDefinitions**, **KeySchema**, **ProvisionedThroughput**: Configurações da tabela.

#### **DynamoDBVpcEndpoint**
- **Descrição**: Endpoint da VPC para DynamoDB permitindo acesso direto e privado sem necessidade de tráfego pela internet.
- **Propriedades**:
  - **VpcId**, **ServiceName**, **VpcEndpointType**, **SubnetIds**, **SecurityGroupIds**, **PolicyDocument**: Especificações do endpoint.
