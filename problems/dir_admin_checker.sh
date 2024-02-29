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
PERMISSION=${PERMISSION:="^(2|6)(0|7)70"}
#-               O
#check if the dirPectories have been created
if [[ -d $DIRECTORY ]]; then
	echo "it exists"
	#check if the ownership is correct
	if [[ $(stat -c "%G" $DIRECTORY) == $OWNER ]]
	then
		echo "correct owner: $OWNER"
	else
		echo "owner $(stat -c "%G" $DIRECTORY) is not $OWNER"
	fi
	#check if it's the right permission, whether you applied the sticky to user or not is irrelevant
	if [[ $(stat -c '%a' $DIRECTORY ) =~ $PERMISSION ]] 
	then
		echo "correct permissions set: $PERMISSION"
	else
		echo "permissions are incorrectly set"
	fi
else
	echo "/common/admin not found"
fi
