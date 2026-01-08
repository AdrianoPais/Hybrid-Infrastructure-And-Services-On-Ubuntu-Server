#!/bin/bash

#
# =========================================================================================#
#
# Projeto: Configuração de Servidor SSH em Ubuntu Server
# Autor: Sérgio Correia / Daniel Santos
#
# Descrição:
# Este script automatiza a instalação e configuração do serviço SSH em um sistema Ubuntu.
#
# =========================================================================================#
#

# O set -e é um comando a correr em Scripts para que este pare a execução
# se houver algum erro em qualquer comando.
set -e

# O que faz o chmod 700: Define permissões de leitura, escrita e execução apenas para o proprietário do arquivo.
chmod 700 config_ssh.sh

# 1 - Instalação e Ativação do Serviço SSH
# O que faz: Instala o pacote openssh-server, inicia o serviço ssh e garante que este arranca automaticamente no boot.

sudo apt update
sudo apt install -y openssh-server
sudo systemctl start ssh
sudo systemctl enable ssh

echo "Instalado o serviço openssh-server."
sleep 1

# 2 - Configuração da Firewall
# O que faz: Permite a porta SSH (22) na firewall UFW e aplica as alterações.

sudo ufw allow ssh
sudo ufw reload

echo "Permitido serviço SSH na firewall."
sleep 1

# 3 - Criação de um backup
# O que faz: Cria uma cópia de segurança do ficheiro sshd_config

sudo cp /etc/ssh/sshd_config "$HOME/sshd_config_backup"
echo "sshd_config copiado com sucesso para home."
sleep 1

# 4 - Configuração do sshd_config
# O que faz: Edita automaticamente o ficheiro de configuração SSH.

sudo sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config
echo "Porta SSH confirmada como 22."
sleep 0.5

sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
echo "Login de root com password desativado."
sleep 0.5

sudo sed -i 's/#MaxSessions 10/MaxSessions 10/' /etc/ssh/sshd_config
echo "Máximo de sessões simultâneas configurado."
sleep 0.5

sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo "Autenticação por password permitida."
sleep 0.5

sudo sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' /etc/ssh/sshd_config
echo "Login com passwords vazias desativado."
sleep 0.5

sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
echo "Autenticação por chave pública ativada."
sleep 0.5

sudo sed -i 's|^#\?AuthorizedKeysFile.*|AuthorizedKeysFile .ssh/authorized_keys|' /etc/ssh/sshd_config
echo "Ficheiro authorized_keys configurado."
sleep 0.5

# 5 - Aplicar as alterações
sudo systemctl reload ssh
echo "Configuração do SSH aplicada."

# 6 - Criação e atualização de permissões
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
echo "Pasta .ssh criada e permissões aplicadas."

# 7 - Criação das RSA Keys
echo "A criar chaves RSA..."
ssh-keygen -t rsa -f "$HOME/.ssh/id_rsa" -N ""
echo "Chaves criadas com sucesso."

# 8 - Configuração da chave pública
cat "$HOME/.ssh/id_rsa.pub" >> "$HOME/.ssh/authorized_keys"
echo "Chave pública adicionada ao authorized_keys."

# 9 - Atualização das permissões
chmod 600 "$HOME/.ssh/authorized_keys"
echo "Permissões do authorized_keys aplicadas."

# 10 - Reload do Serviço
sudo systemctl reload ssh
sudo systemctl status ssh

# 11 - Mensagem Final
echo "Script SSH concluído com sucesso."
echo "Recomenda-se um reboot do sistema."
