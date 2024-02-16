#!/bin/bash
#
DESC="
This problem checks for the creation of a group owned directory with specific permissions
DIRECTORY: The location of the directory
OWNER: The group ownership name of the directory
PERMISSION: The string or regex used to check for group ownership permissions
"
#-
DIRECTORY=${DIRECTORY:="/common/admin"}
OWNER=${OWNER:="admin"}
PERMISSION=${PERMISSION:="^(2|6)770"}
#-               O
#check if the dirPectories have been created
if [[ -d $DIRECTORY ]]; then
	echo "it exists"
	#check if the ownership is correct
	[[ $(stat -c "%G" $DIRECTORY) == $OWNER ]] && echo "correct owner: $OWNER"
	#check if it's the right permission, whether you applied the sticky to user or not is irrelevant
	[[ $(stat -c '%a' $DIRECTORY ) =~ $PERMISSION ]] && echo "correct permissions set: $PERMISSION"
else
	echo "/common/admin not found"
fi
