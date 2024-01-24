#!/bin/bash
PACKAGES="nfs-utils "
SHARE_DIR="/user-homes"
SHARE_USERS=( $(echo "production"{1..30}) )
SHARE_IDS="300"
DEFAULT_UMASK=$(umask)
SHARE_UMASK="0027"
DEFAULT_PASS="redhat"
NETWORK="10.10.10.0/24"
#setup hostname
echo $LAB_A_HOSTNAME > /etc/hostname
#save the default swap size of the device
free --mega | awk '/Swap/ {print $2}' >> /root/.swapinfo
#this installs the basic packages and sets up the services running here
yum install -y $PACKAGES
#we disable all the repos
find /etc/yum.repos.d/ -type f -exec sed -i 's/enabled=1/enabled=0/' {} \;
#create users
#mkdir $SHARE_DIR
#chown nobody:root $SHARE_DIR
#chmod o+rx $SHARE_DIR
for idx in ${!SHARE_USERS[@]}
do
	user=${SHARE_USERS[idx]}
	uid="$SHARE_IDS$idx"
	useradd -p $(openssl passwd $DEFAULT_PASS ) -u $uid -U -m -d $SHARE_DIR/$user $user
	echo "success" > $SHARE_DIR/$user/.verification
done
umask $DEFAULT_UMASK
#setup nfs
#systemctl enable --now nfs-server
#firewall-cmd --permanent --add-service={nfs,rpc-bind,mountd}
#firewall-cmd --reload
#echo "$SHARE_DIR $NETWORK(rw,sync)" >> /etc/exports
#exportfs -avr
