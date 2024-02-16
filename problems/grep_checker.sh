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
cat /root/search.txt | grep $CONTENT &> /dev/null && echo success || echo fail
