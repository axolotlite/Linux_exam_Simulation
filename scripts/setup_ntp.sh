#!/bin/bash
#
SHARE_DIR="/user-homes"
DEFAULT_UMASK=$(umask)
SHARE_UMASK="0027"
DEFAULT_PASS="redhat"
NETWORK="10.10.10.0/24"
#install the repository
yum install -y nfs-utils
#create a directory
mkdir $SHARE_DIR
chown nobody:root $SHARE_DIR
chmod o+rx $SHARE_DIR
#setup the nfs server
systemctl enable --now nfs-server
firewall-cmd --permanent --add-service={nfs,rpc-bind,mountd}
firewall-cmd --reload
#export directories
echo "$SHARE_DIR $NETWORK(rw,sync)" >> /etc/exports
exportfs -avr
