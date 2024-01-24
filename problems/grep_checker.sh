#!/bin/bash
FILE="/root/search.txt"
CONTENT="home"
#this checks the content of a grep
cat /root/search.txt | grep $CONTENT &> /dev/null && echo success || echo fail
