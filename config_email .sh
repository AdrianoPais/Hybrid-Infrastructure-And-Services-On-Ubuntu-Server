#!/bin/bash

#
# =========================================================================================#
#
# Projeto: Configuração de Servidor de Email (Mailcow em Docker)
# Autor: Sérgio Correia / Daniel Santos
#
# Descrição:
# Este script automatiza a instalação e configuração de um servidor de email completo
# utilizando o Mailcow (Dockerized) em Ubuntu Server.
#
# Inclui:
#  - Atualização do sistema
#  - Instalação de dependências essenciais
#  - Instalação do Docker e Docker Compose (plugin)
#  - Preparação do ambiente Mailcow
#  - Arranque dos serviços de email
#
# O servidor destina-se a um ambiente DMZ.
#
# =========================================================================================#
#

# O set -e faz com que o script pare imediatamente se ocorrer algum erro,
# evitando instalações incompletas ou configurações inconsistentes.
set -e

# Atualiza a lista de pacotes e aplica todas as atualizações disponíveis
apt update && apt upgrade -y

# Instala pacotes base necessários para Docker, Git e scripts futuros
apt install curl nano git apt-transport-https ca-certificates gnupg2 software-properties-common -y

# Para evitar conflitos nas portas 80 e 443 (usadas pelo Mailcow),
# são parados e desativados serviços web locais, caso existam.
systemctl stop apache2 2>/dev/null
systemctl disable apache2 2>/dev/null

systemctl stop nginx 2>/dev/null
systemctl disable nginx 2>/dev/null

# Download e importação da chave GPG oficial do Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Adiciona o repositório oficial do Docker à lista de fontes APT
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list

# Atualiza novamente os repositórios para incluir o Docker
apt update

# Instala o Docker Engine, CLI e o plugin oficial Docker Compose
apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

# Inicia o serviço Docker e garante que este arranca automaticamente no boot
systemctl start docker
systemctl enable docker

# Muda para a diretoria /opt (local recomendado para serviços)
cd /opt

# Clona o repositório oficial do Mailcow
git clone https://github.com/mailcow/mailcow-dockerized
cd mailcow-dockerized

# Executa o script interativo de configuração do Mailcow
# Durante este passo devem ser definidos:
#  - FQDN (ex: mail.paca.cloud)
#  - Timezone (ex: Europe/Lisbon)
#  - Ativação do ClamAV (recomendado se houver +4GB RAM)
./generate_config.sh

# Descarrega todas as imagens Docker necessárias para o Mailcow
docker compose pull

# Inicia todos os containers do Mailcow em segundo plano
docker compose up -d

echo "----------------------------------------------------"
echo "Instalação concluída!"
echo "Aceda via browser: https://(o_seu_ip_ou_dominio)"
echo "Login padrão: admin / moohoo"
echo "----------------------------------------------------"