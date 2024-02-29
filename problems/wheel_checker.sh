#!/bin/bash
#this checks if the wheel group has been enabled or not, this may be further segmented
#-
USER=${USER:="ahmed"}
GROUP=${GROUP:="wheel"}
#-
#check if user exists
if [[ $(id $USER ) ]] 
then
	echo "use $USER was created successfully"
else
       	echo "user $USER doesnt exist, exiting..." 
	exit 1
fi
if [[ $(groups $USER | grep wheel ) ]]
then
	echo "$USER is in $GROUP group"
else
	echo "$USER is not in $GROUP group"
fi
if [[ $(grep "^%$GROUP" /etc/sudoers ) ]]
then
       	echo "$GROUP group setup correctly" 
else
	echo "$GROUP incorrectly set"
fi
