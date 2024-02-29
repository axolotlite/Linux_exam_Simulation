#!/bin/bash

#This script will check your selinux configuration of a custom httpd port.
#-
PORT=${PORT:=82}
PKG=${PKG:="httpd_exam"}
PORT_CONTEXT=${PORT_CONTEXT:="http_port_t"}
SERVICE=${SERVICE:="httpd"}
CURL_URL=${CURL_URL:="http://localhost:82/"}
#-
#first, port configuration
if [[ $(semanage port -l  2>/dev/null |grep ^$PORT_CONTEXT | grep -wo $PORT ) ]]
then
	echo "port $PORT access given to $SERVICE"
else
	echo "port $PORT access not given to $SERVICE"
fi
#check if port is open
if [[ $(firewall-cmd --list-ports 2>/dev/null | grep -wo $PORT ) ]]
then
	echo "port $PORT configured through firewall"
else 
	echo "port $PORT not actively enabled in firewall"
fi
#second we check if the httpd is installed
if [[ $(rpm -q $PKG ) ]]
then
	echo "package $PKG installed "
else 
	echo "package $PKG not installed"
fi
#check if httpd is enabled and active
if [[ $(systemctl is-enabled $SERVICE  ) ]]
then
       	echo "$SERVICE is enabled"
else
	echo "$SERVICE is not enabled"
fi
if [[ $(systemctl is-active  $SERVICE ) ]]
then
	echo "$SERVICE started"
else
	echo "$SERVICE is not started"
fi
#check if the content are available locally
if [[ $(curl $CURL_URL ) ]]
then
       	echo "curl url $CURL_URL successful"
else 
	echo "curl url $CURL_URL failure"
fi
