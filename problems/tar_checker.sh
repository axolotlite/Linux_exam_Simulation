#!/bin/bash
DESC="
The tarball the user creates which should contain a verification file from the setup script
TARBALL: the location of the tarball to check
"
#-
TARBALL=${TARBALL:="/root/test.tar.gz"}
#-

#i'm unsure how to do this correctly, so for the mean time i'll do it simply

if [[ -f $TARBALL ]] 
then 
	echo "tarball file found"
	if [[ $(tar -tf $TARBALL | grep ".verification" ) ]]
	then
	       	echo "archive success"
	else 
		echo "archive failure"
	fi
else
	echo "tarball file not found"
fi
