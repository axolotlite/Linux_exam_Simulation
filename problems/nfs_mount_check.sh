#!/bin/bash
SHARE_DIR="/localhome"
USER="production5"
FILE_VERIFICATION=".verification"
#first, check if the directory is mounted
if [[ $(mount | grep $SHARE_DIR) ]] 
then
	echo share directory mounted
	sudo -u production5 cat $SHARE_DIR/$USER/.verification &>/dev/null && echo user mounted successfully
fi
