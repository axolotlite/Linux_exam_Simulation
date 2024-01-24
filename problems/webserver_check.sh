#!/bin/bash

#This script will check your selinux configuration of a custom httpd port.

#first, port configuration
port=$(semanage port -l  |grep ^http_port_t | grep -wo 82)
port_status=$(echo $?)
#second we check if the httpd is installed
httpd=$(rpm -q httpd)
httpd_status=$(echo $?)
#check if httpd is enabled and active
enabled=$(systemctl is-enabled httpd)
enabled_status=$(echo $?)
active=$(systemctl is-active httpd)
active_status=$(echo $?)
#check if the content are available locally
response=$(curl http://localhost:82/)
if [[ $response == "success" ]] then;
	response_status=0
else
	response_satus=1
fi
#finally check if it's available remotely
ssh something

