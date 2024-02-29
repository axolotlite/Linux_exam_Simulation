#!/bin/bash
#
DESC="
This problem checks for piping a grep output
FILE: The file the user redirects to
CONTENT: A string the user should have grepped for
"
#-
FILE=${FILE:="$HOME/search.txt"}
CONTENT=${CONTENT:="home"}
#-
#this checks the content of a grep
if [[ $(cat $FILE | grep $CONTENT ) ]] 
then
	echo "substring $CONTENT was found in $FILE"
else
	echo "substring $CONTENT was not found in $FILE"
fi
