#!/bin/bash
DESC="
This script creates a custom repo 
"
#-
REPODIR=${REPODIR:="/var/www/html/custom"}
#-
dnf config-manager --set-enabled crb
dnf install epel-release epel-next-release -y
dnf install createrepo httpd httpd-tools -y

#download httpd
systemctl enable --now httpd
#setting up apache server to serve the repo
firewall-cmd --add-service=http --permanent
firewall-cmd --reload

#create the custom repo and default repos
mkdir -p $REPODIR/{Packages,repodata}
createrepo /var/www/html/custom/
#ensure selinux permissions are set correctly, for some reason they sometimes break.
#todo with chcon

