#!/bin/bash
#this checks if the user added the custom repo
#get the baseurls to check if one of them contain classroom 
BASEURLS=$(yum repolist -v 2> /dev/null | grep -oP 'http://\K\S+')
get_id () {
	echo $(yum repolist -v 2> /dev/null | grep -B 7 "$1" | awk '/Repo-id/ {print $NF}')
}

REPOS=""
REPO_EXISTS=0
for url in $BASEURLS
do
#echo $url
# check if a "classroom" substring exists in the urls
	if [[ "$url" == *"classroom"* ]]; then
		echo $url
		REPOS="$REPOS $(get_id $url)"
		((REPO_EXISTS++))
	fi
done
echo $REPOS
#if the repo exists, then disable all other repos and attempt to download something
if [[ $REPO_EXISTS ]]; then
	yum update --disablerepo * --enablerepo $REPOS
	verification="$(yum --disablerepo * --enablerepo $REPOS list available 2> /dev/null| awk '/verification/ {print $1}')"
	[[ $verification == *"verification"* ]] && echo "yes"

#echo $REPOS
#echo $REPO_EXISTS
fi
