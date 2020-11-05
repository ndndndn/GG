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
acl localnet src 10.8.0.0/24	# RFC1918 possible internal network
acl localnet src 172.16.0.0/12	# RFC1918 possible internal network
acl localnet src 192.168.0.0/16	# RFC1918 possible internal network
acl localnet src fc00::/7       # RFC 4193 local private network range
acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines
acl SSL_ports port 443
acl SSL_ports port 992
acl SSL_ports port 995
acl SSL_ports port 5555
acl SSL_ports port 80
acl Safe_ports port 80		# http
acl Safe_ports port 21		# ftp
acl Safe_ports port 443		# https
acl Safe_ports port 70		# gopher
acl Safe_ports port 210		# wais
acl Safe_ports port 1025-65535	# unregistered ports
acl Safe_ports port 280		# http-mgmt
acl Safe_ports port 488		# gss-http
acl Safe_ports port 591		# filemaker
acl Safe_ports port 777		# multiling http
acl Safe_ports port 992		# mail
acl Safe_ports port 995		# mail
acl CONNECT method CONNECT
acl vpnservers dst ipmokasito
acl vpnservers dst 127.0.0.1
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localhost manager
http_access allow localnet
http_access allow localhost
http_access allow vpnservers
http_access deny !vpnservers
http_access deny manager
http_access allow all
acl all src 0.0.0.0/0
http_access allow all
http_port 0.0.0.0:8080
http_port 0.0.0.0:8989
http_port 0.0.0.0:3128
http_port 0.0.0.0:8000
http_port 0.0.0.0:8888
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
