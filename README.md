# Hybrid-Infrastructure-And-Services-On-Ubuntu-Server

Este repositório documenta a implementação do projeto Paca Cloud, uma infraestrutura de rede completa e heterogénea. O projeto demonstra a integração de serviços críticos em diferentes ecossistemas, garantindo a interoperabilidade entre Linux (Ubuntu/Mint) e Windows Server.  

## Arquitetura do Sistema

A solução foi desenhada para simular um ambiente empresarial real, utilizando:

Ubuntu Server: Atuando como o núcleo de serviços Linux (Web, Email e FTP).   
Windows Server: Responsável pela gestão de diretório, políticas de grupo (GPO) e serviços de infraestrutura específicos de Windows.  
Linux Mint: Utilizado como estação de trabalho (Cliente) para validação de conectividade, resolução de nomes e acesso aos serviços.  

## Componentes e Automação

O projeto foca-se na rapidez de implementação e na consistência das configurações através de scripts Bash.  

### Serviços Linux (Ubuntu Server)

- Web Server (Apache): Configuração de alojamento web com suporte a múltiplos sites.   
- Email (Postfix/Dovecot): Servidor de correio completo com protocolos SMTP e IMAP.  
- FTP: Implementação de VFTPD com suporte a utilizadores locais e permissões estabelecidas, Fail2Ban e Configuração de modo passiva para compatibilidade com NAT. 
- SSH: Alteração da porta padrão e desativação de login de Root, Banner de aviso legal e monitorização de logs, juntamente com bloqueio automático de ataques de força bruta.

### Serviços Windows (Windows Server)

- Active Directory (AD DS): Gestão centralizada de utilizadores e permissões.
- DNS & DHCP: Configuração de redundância ou segmentação de rede para clientes Windows e Linux .   

### Validação em Cliente (Linux Mint)

Testes de resolução de nomes (DNS).   
Verificação de atribuição de IPs dinâmicos (DHCP).  
Acesso a pastas partilhadas e serviços web.  

## Tecnologias Utilizadas

Sistemas: Ubuntu Server 24.04, Windows Server 2022, Linux Mint Cinnamon, Windows 10 Pro.
Automação: Bash Scripting.   
Segurança: Fail2Ban, Firewalld/UFW, SELinux/AppArmor.  
Rede: NAT, Port Forwarding, IPv4 (Classe C).  

Como Utilizar

1. Clonar o repositório:

git clone https://github.com/AdrianoPais/Hybrid-Infrastructure-And-Services-On-Ubuntu-Server.git
cd Hybrid-Infrastructure-And-Services-On-Ubuntu-Server

Configurar os Scripts: Os scripts estão organizados por serviço. Garante que defines as interfaces de rede corretas para o teu ambiente virtual.  

chmod +x *.sh
sudo ./config_webserver.sh

## Checklist de Segurança

[x] Enrijecimento (Hardening) de SSH com porta personalizada.
[x] Configuração de NAT/Masquerading para isolamento da LAN.
[x] Regras de Firewall persistentes para serviços Web e Email.
[x] Monitorização de logs em tempo real.

## Autor

Sérgio Correia.
Projeto realizado no âmbito da formação na ATEC.
