#!/bin/bash
#this checks if the user added the custom repo
#get the baseurls to check if one of them contain classroom
BASEURLS=( "www.classroom.example.com/AppStream" "www.classroom.example.com/BaseOS" "www.classroom.example.com/custom" )
baseurls=($(yum repolist -v 2> /dev/null | grep -oP 'http://\K\S+'))
VERIFICATION_PKG="httpd_exam"
#check if the repos have been configured correctly
if [[ $(echo ${baseurls[@]} ${BASEURLS[@]} | tr ' ' '\n' | sort | uniq -u) == "" ]]; then
	echo repos configured correctly 
	yum search $VERIFICATION_PKG 2> /dev/null | grep $VERIFICATION_PKG &>/dev/null && echo custom packages reachable || echo custom packages unreachable
else
	echo repos are not configured correctly 
	exit 1
fi

