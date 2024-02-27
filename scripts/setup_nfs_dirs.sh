#!/bin/bash
DESC="
This script sets the nfs directory users

SHARE_DIR: the directory where the share should be placed in
SHARE_USERS: the array containing the users in the share
SHARE_IDS: the starting id for share users
SHARE_UMASK: the umask that should be applied during share directory creation
DEFAULT_PASS: the default password for all the users
"
#-
SHARE_DIR=${SHARE_DIR:="/user-homes"}
SHARE_USERS=${SHARE_USERS:=( $(echo "production"{1..30}) )}
SHARE_IDS=${SHARE_IDS:="300"}
SHARE_UMASK=${SHARE_UMASK:="0027"}
DEFAULT_PASS=${DEFAULT_PASS:="redhat"}
MODE=${MODE:="client"}
#-
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
