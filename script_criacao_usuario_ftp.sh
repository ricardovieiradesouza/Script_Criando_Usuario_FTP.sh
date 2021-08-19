##########################################################
####SCRIPT DE INSTALAÇO E CONFIGURAÇO DO SERVIDOR FTP#####
###                                                ########
##########################################################
# Autor Ricardo Souza
# Data 18/07/2021
# Versão 1.0.2
# e-mail ricardosouza.suporte@outlook.com

echo "#############################################"
echo "##### Iniciando procedimento.......     #####"
echo "#############################################"
echo
#Instalar serviçFTP

echo "Instalando pacote FTP"
sudo yum install vsftpd -y
sudo systemctl start vsftpd
sudo systemctl enable vsftpd
#sudo touch /etc/vsftpd/chroot_list
#sudo touch /etc/chroot_list
echo " ===== Adicionando regras no firewall =========="

#Adicionando regras de firewall
sudo firewall-cmd --zone=public --permanent --add-port=21/tcp
sudo firewall-cmd --zone=public --permanent --add-service=ftp
sudo firewall-cmd --reload
echo
#Editar arquivo de configuraçs
echo "###################################"
echo "######Editando configuraçs ######"
echo "###################################"
sudo cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.default
sudo sed -i 's/anonymous_enable=YES/anonymous_enable=NO/g' /etc/vsftpd/vsftpd.conf
sudo sed -i 's/local_enable=NO/local_enable=YES/g' /etc/vsftpd/vsftpd.conf
sudo sed -i 's/write_enable=YES/write_enable=NO/g' /etc/vsftpd/vsftpd.conf
sudo sed -i 's/connect_from_port_20=YES/connect_from_port_20=NO/g' /etc/vsftpd/vsftpd.conf
sudo sed -i 's/#chroot_local_user=YES/chroot_local_user=YES/g' /etc/vsftpd/vsftpd.conf
#sudo sed -i 's/#chroot_list_enable=YES/chroot_list_enable=YES/g' /etc/vsftpd/vsftpd.conf
sudo sed -i 's/#userlist_enable=YES/userlist_enable=YES/g' /etc/vsftpd/vsftpd.conf
echo -e "userlist_file=/etc/vsftpd/user_list" >> /etc/vsftpd/vsftpd.conf
echo -e "userlist_deny=NO" >> /etc/vsftpd/vsftpd.conf
echo -e "allow_writeable_chroot=YES" >>/etc/vsftpd/vsftpd.conf
echo
echo "#####COMPLETE...########"
sleep 2
echo "###########################"
echo "##Configurando servicos...##"
echo "###########################"
echo
echo "Configurando User Linux. Cliente: $HOSTNAME"
SENHA=*@FTP-`hostname -s`@*

echo "Adicionando usuario"
sudo useradd -s /sbin/nologin -d /home/teste -M ricardo

#sudo useradd -s /sbin/nologin -d /home/teste -M rvs

sudo usermod -G ricardo ricardo

sudo usermod -p $(openssl passwd -1 $SENHA) ricardo

#adicionando usuario cbmonitor a lista de permissoes de acesso ftp
echo "ricardo" | sudo tee .a /etc/vsftpd/user_list

#removendo autorizacao de usuario com shell ativa para acessar FTP
sudo sed -i '4s/^/#/' /etc/pam.d/vsftpd

echo "Complete.."

sudo touch /etc/vsftpd/ARQUIVO
sudo chmod 777 /etc/vsftpd/ARQUIVO
sudo echo "#########" >> /etc/vsftpd/ARQUIVO
sudo echo "Data de Instalacao: `date`" >> /etc/vsftpd/ARQUIVO
sudo echo "Variavel HOSTNAME: `hostname -s`" >> /etc/vsftpd/ARQUIVO
#PASS=/etc/vsftpd/ARQUIVO
sudo echo "Senha do user ricardo: *@FTP-`hostname -s`@*" >> /etc/vsftpd/ARQUIVO

sudo echo "#########" >> /etc/vsftpd/ARQUIVO
sudo chmod 400 /etc/vsftpd/ARQUIVO
echo
echo "Iniciando Servico......."
sudo systemctl restart vsftpd
echo " "

sleep 2


#sudo systemctl enable smb
echo "Complete..."
echo
echo
echo "#########################################"
echo "### `sudo cat /etc/vsftpd/ARQUIVO | tail -n 2 | grep "user"` "

echo "###########################################" 
echo "###CONCLUIDO...###"
echo "#########################################"
