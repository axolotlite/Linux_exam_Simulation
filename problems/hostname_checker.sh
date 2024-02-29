#!/bin/bash
DESC="
This checks if the user set the hostname correctly
HOSTNAME: the hostname the user should've set
"
#-
HOSTNAME=${HOSTNAME:="khaldoom"}
#-

if [[ $(hostname) =~ "$HOSTNAME" ]] 
then
	echo "hostname set correctly" 
else
	echo "hostname set incorrectly"
fi
