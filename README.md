# Atividade de Linux PB AWS - IFMS -ESTÁCIO DE SÁ

## Objetivo da atividade: 
Este repositório contém os requisitos e instruções para realizar uma atividade que envolve a configuração de recursos na AWS e a implementação de um ambiente no Linux. Os principais objetivos incluem a criação de uma instância EC2 na AWS, a configuração do NFS (Network File System) no Linux, e a automatização de um script para verificar o status de um serviço Apache e gerar logs que serão enviados ao diretorio nfs.

# Requisitos Linux:

• Configurar o NFS

• Criar um diretorio dentro do filesystem do 
NFS com seu nome

• Subir um apache no servidor - o apache deve 
estar online e rodando

• Desenvolver um script que, ao ser executado, valide o status do apache, registre a data, hora, nome do serviço, status (online ou offline) e uma mensagem personalizada. Este script deve gerar dois arquivos de saída, um para o serviço online e outro para o serviço offline, enviando esses resultados para o diretório no NFS designado.

• Preparar a execução automatizada do script a 
cada 5 minutos

# AWS:

• Criar uma VPC Com uma subnet publica

• Criar um Security Group Com as seguintes regras de entrada:  (22/TCP, 111/TCP e UDP, 
2049/TCP/UDP, 80/TCP, 443/TCP)

• Criar uma Chave de Acesso Público .pem

• Criar uma Instância EC2 com o sistema 
operacional Amazon Linux 2 (Família 
t3.small, 16 GB SSD)

• Anexar a instância EC2, sua vpc criada, subnet e security group

• Criar um elastic Ip e anexar a sua instância EC2, assim sua instância terá um ip fixo

Após todo este processo, você deverá acessar sua instância via ssh usando sua chave .pem por meio de um terminal, com o comando:

```
ssh -i /caminho/para/sua/chave-privada.pem ec2-user@seu-ipv4-publico
```

após receber o acesso a sua instância ec2, você precisara de permissão root para as configurações exigidas pela atividade, basta usar o comando:
```
sudo su
```

# Linux

Agora que você ja configurou toda a parte da aws e possui acesso root a sua instância, chegou a hora de configurar o NFS, Apache e o Script pedido pela atividade

# Instruções para configuração NFS:

• Instale o servidor NFS com o comando:

```
yum install nfs-utils
```

• Crie um diretorio para o NFS com o seu nome usando o comando:

```
mkdir /mnt/seu_nome
```

• Edite o arquivo de configuração do NFS:

```
nano /etc/exports

/caminho_do_seu_diretorio_nfs ip_acesso(rw,no_root_squash,sync)
```

• Inicie e habilite o serviço com o comando: 

```
systemctl start nfs-server && systemctl enable nfs-server
```

# Instruções para configurações Apache:

• Instale o Apache: 

```
yum install httpd -y
```

• Inicie e habilite o apache:

```
systemctl start httpd && systemctl enable httpd
```

# Instruções para Criação do Script de Logs:

• Crie um arquivo nano com a extensão sh:

```
nano apache_verificador.sh
```

• Edite o arquivo sh:

```ruby
#!/bin/bash

# Diretório NFS
NFS_DIR="/caminho/do/seu/diretorio/nfs"

# Nome do serviço
SERVICO="Apache"

# Data e Hora
DATA_HORA=$(date +"%Y-%m-%d %H:%M:%S")

# Verifica se o Apache está rodando
systemctl is-active --quiet httpd

# Captura o código de saída do comando anterior
CODIGO_SAIDA=$?

# Arquivo de saída para o serviço ONLINE
ARQUIVO_ONLINE="${NFS_DIR}/${DATA_HORA}_Online_${SERVICO}.txt"

# Arquivo de saída para o serviço OFFLINE
ARQUIVO_OFFLINE="${NFS_DIR}/${DATA_HORA}_Offline_${SERVICO}.txt"

# Mensagem padrão
MENSAGEM="Status do serviço ${SERVICO} em ${DATA_HORA}:"

# Verifica o status do serviço e gera o arquivo correspondente
if [ $CODIGO_SAIDA -eq 0 ]; then
    echo "${MENSAGEM} ONLINE" > "${ARQUIVO_ONLINE}"
    echo "Apache está rodando. Arquivo ONLINE gerado em: ${ARQUIVO_ONLINE}"
else
    echo "${MENSAGEM} OFFLINE" > "${ARQUIVO_OFFLINE}"
    echo "Apache não está rodando. Arquivo OFFLINE gerado em: ${ARQUIVO_OFFLINE}"
fi

```

• Torne o arquivo sh executavel:

```
chmod +x apache_verificador.sh
```

• Abra o crontab para automatização do script:

```
crontab -e
```

• Edite o crontab com o intervalo de tempo para execução do script:

```
*/5 * * * * /caminho_do_script

```
