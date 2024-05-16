### Recursos do template CloudFormation:

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
- **Descrição**: Grupo de Auto Scaling que gerencia a escalabilidade das instâncias com base na configuração de lançamento.
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
  - **TableName**,

 **AttributeDefinitions**, **KeySchema**, **ProvisionedThroughput**: Configurações da tabela.

#### **DynamoDBVpcEndpoint**
- **Descrição**: Endpoint da VPC para DynamoDB permitindo acesso direto e privado sem necessidade de tráfego pela internet.
- **Propriedades**:
  - **VpcId**, **ServiceName**, **VpcEndpointType**, **SubnetIds**, **SecurityGroupIds**, **PolicyDocument**: Especificações do endpoint.

Estes recursos são projetados para criar uma infraestrutura de rede robusta e escalável, com foco na segurança e eficiência operacional, apoiando a implementação e operação de aplicações na AWS.

```bash
teste
```