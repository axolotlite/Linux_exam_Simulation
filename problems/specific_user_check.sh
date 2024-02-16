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
[[ $(id -u $USER) == $USERID ]] && echo $USER created with correct uid || echo user not created up to specifications
