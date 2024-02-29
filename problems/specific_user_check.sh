#!/bin/bash
#this should be added to user checker, later.
DESC="
This problem is to check for username and his user id
USER: the created username
USERID: the id of the created user
"
#-
USER=${USER:="alies"}
USERID=${USERID:=1326}
#-
if [[ $(id -u $USER) == $USERID ]]
then
	echo "$USER created with correct uid"
else
	echo "user not created up to specifications"
fi
