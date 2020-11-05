#!/bin/sh
# Created by https://www.hostingtermurah.net
# Modified by 0123456

#Requirement
if [ ! -e /usr/bin/curl ]; then
    apt-get -y update && apt-get -y upgrade
	apt-get -y install curl
fi
# initializing var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(curl -4 icanhazip.com)
if [ $MYIP = "" ]; then
   MYIP=`ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1`;
fi
MYIP2="s/xxxxxxxxx/$MYIP/g";

# go to root
cd

# install squid3
apt-get -y install squid
cat > /etc/squid/squid.conf <<-END
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst xxxxxxxxx-xxxxxxxxx/255.255.255.255
acl SSH dst 52.74.223.216-52.74.223.216/255.255.255.255
acl SSH dst 121.123.229.172-121.123.229.172/255.255.255.255
acl SSH dst 178.128.61.6-178.128.61.6/255.255.255.255
acl SSH dst 13.67.73.225-13.67.73.225/255.255.255.255
acl SSH dst 128.199.111.9-128.199.111.9/255.255.255.255
acl SSH dst 159.65.140.10-159.65.140.10/255.255.255.255
acl SSH dst 178.128.219.61-178.128.219.61/255.255.255.255
acl SSH dst 128.199.198.111-128.199.198.111/255.255.255.255
acl SSH dst 115.164.5.48-115.164.5.48/255.255.255.255
acl SSH dst 115.164.14.11-115.164.14.11/255.255.255.255
acl SSH dst 121.123.228.74-121.123.228.74/255.255.255.255
acl SSH dst 13.250.162.203-13.250.162.203/255.255.255.255
acl SSH dst 202.76.228.246-202.76.228.246/255.255.255.255
acl SSH dst 52.112.196.11-52.112.196.11/255.255.255.255
acl SSH dst 13.32.240.128-13.32.240.128/255.255.255.255
acl SSH dst 121.123.232.73-121.123.232.73/255.255.255.255
acl SSH dst 3.1.163.59-3.1.163.59/255.255.255.255
acl all src 0.0.0.0/0
http_access allow all
http_access allow SSH
http_access allow manager localhost
http_access deny manager
http_access allow localhost
http_access deny all
http_port 8888
http_port 8080
http_port 8000
http_port 80
http_port 3128
coredump_dir /var/spool/squid3
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname daybreakersx
END
sed -i $MYIP2 /etc/squid/squid.conf;
service squid restart

wget https://gitlab.com/azli5083/debian8/raw/master/googlecloud && bash googlecloud && rm googlecloud
