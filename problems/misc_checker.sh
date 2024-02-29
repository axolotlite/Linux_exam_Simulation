#!/bin/bash
#This file will probably be split into multiple files in an upcoming commit
DESC="
check the umask of user
USER: user to check the umask
UMASK: the supposed umask that the user set
MAXDAYS: the user defined expiration date
"
#-
USER=${USER:="natasha"}
UMASK=${UMASK:="0277"}
MAXDAYS=${MAXDAYS:="20"}
NOPASS_ID=${NOPASS_ID:="%admin"}
WELCOME=${WELCOME:="Welcome to Advantage Pro"}
#-
if [[ $(sudo -u $USER -i umask) == $UMASK ]] 
then
	echo "umask set correctly"
else
	echo "umask set incorrectly"
fi

#default password expiry date should be set to 20 days
if [[ $(awk '/PASS_MAX_DAYS.*[0-9]/ {print $NF}' /etc/login.defs ) == $MAXDAYS ]]
then
	echo "expiration date set correctly" 
else
	echo "expiration date set wrong"
fi
#check if sudoers has a group with no passwd to invoke sudo
if [[ $(grep "^$NOPASS_ID.*NOPASSWD" /etc/sudoers) ]]
then
	echo "sudoers set correctly"
else
	echo "sudoers set falsely"
fi
#check for special welcome message
if [[ $(grep "$WELCOME" /home/$USER/.bash_profile || grep "$WELCOME" /home/$USER/.bashrc) ]]
then
	echo "string was found"
else
	echo "string '$WELCOME' was not found"
fi
