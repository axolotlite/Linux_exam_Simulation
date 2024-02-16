#!/bin/bash

#This script will check your selinux configuration of a custom httpd port.
#-
PORT=${PORT:=82}
PKG=${PKG:="httpd_exam"}
PORT_CONTEXT=${PORT_CONTEXT:="http_port_t"}
SERVICE=${SERVICE:="httpd"}
#-
#first, port configuration
semanage port -l  2>/dev/null |grep ^$PORT_CONTEXT | grep -wo $PORT &>/dev/null && echo port access given to httpd
#check if port is open
firewall-cmd --list-ports 2>/dev/null | grep -wo $PORT &>/dev/null && echo port configured through firewall || echo port not actively enabled in firewall
#second we check if the httpd is installed
rpm -q $PKG &>/dev/null && echo package installed || echo package not installed
#check if httpd is enabled and active
systemctl is-enabled &>/dev/null $SERVICE && echo $SERVICE is enabled || echo $SERVICE is not enabled
systemctl is-active $SERVICE &>/dev/null && echo $SERVICE started || echo $SERVICE is not started
#check if the content are available locally
curl http://localhost:82/ &> /dev/null && echo curl successful || echo curl failure

