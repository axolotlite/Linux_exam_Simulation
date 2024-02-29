#!/bin/bash
DESC="
This problem checks if the user added the custom repo
BASEURLS: 
	This is an array containing the urls of the custom repos reperated by spaces
	format:
		url1/reponame1 url2/reponame2
VERIFICATION_PKG: a custom package that should be checked within the repo to ensure that it's configured successfully

"
#get the baseurls to check if one of them contain classroom
#-
BASEURLS=${BASEURLS:="www.classroom.example.com/AppStream www.classroom.example.com/BaseOS www.classroom.example.com/custom"}
VERIFICATION_PKG=${VERIFICATION_PKG:="httpd_exam"}
#-

baseurls=($(yum repolist -v 2> /dev/null | grep -oP 'http://\K\S+'))
#check if the repos have been configured correctly
repos=$(echo ${baseurls[@]} ${BASEURLS[@]} | tr ' ' '\n' | sort | uniq -u)
if [[ $repos == "" ]]; then
	echo repos configured correctly 
	if [[ $(yum search $VERIFICATION_PKG 2> /dev/null | grep $VERIFICATION_PKG ) ]]
	then
		echo "custom packages reachable"
	else 
		echo "custom packages unreachable"
	fi
else
	echo "Not all repos were configured correctly"
	echo "These repos were not configured:"
	for repo in $repos
	do
		echo -e "\t- $repo"
	done

	exit 1
fi

