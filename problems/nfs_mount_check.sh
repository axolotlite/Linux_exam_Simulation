#!/bin/bash
#
DESC="
This problem checks for mounting an nfs home directory using autofs
SHARE_DIR: The nfs local mount location
USER: The user that owns the mounted directory
FILE_VERIFICATION: the file inside the directory to check if its successfully mounted
"
#-
SHARE_DIR=${SHARE_DIR:="/localhome"}
USER=${USER:="production5"}
FILE_VERIFICATION=${FILE_VERIFICATION:=".verification"}
#-
#first, check if the directory is mounted
if [[ $(mount | grep $SHARE_DIR) ]] 
then
	echo share directory mounted
	sudo -u production5 cat $SHARE_DIR/$USER/.verification &>/dev/null && echo user mounted successfully
fi
