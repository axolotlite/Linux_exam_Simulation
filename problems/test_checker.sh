#!/bin/bash
DESC="
This script tests the checking scripts
"
#-
MESSAGE=${MESSAGE:="Hello There, I've been successfully deployed"}
LOCATION=${LOCATION:="/root/message.txt"}
#-

if [[ $(cat $LOCATION) == "$MESSAGE" ]]
then
	echo "test successful!" 
else
	echo "test failure..."
fi
