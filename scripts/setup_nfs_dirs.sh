#!/bin/bash
#This script sets the nfs directory users
#
SHARE_DIR="/user-homes"
SHARE_USERS=( $(echo "production"{1..30}) )
SHARE_IDS="300"
SHARE_UMASK="0027"
DEFAULT_PASS="redhat"
MODE="client"
umask $SHARE_UMASK
for idx in ${!SHARE_USERS[@]}
do
        user=${SHARE_USERS[idx]}
        uid="$SHARE_IDS$idx"
        useradd -p $(openssl passwd $DEFAULT_PASS ) -u $uid -U -m -d $SHARE_DIR/$user -m $user
	if [[ $MODE=="host" ]]
	then
	        echo "success" > $SHARE_DIR/$user/.verification
	fi
done
if [[ $MODE=="client" ]]
then
	rm -rf $SHARE_DIR
fi
