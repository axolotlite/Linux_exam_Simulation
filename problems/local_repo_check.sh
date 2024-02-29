#!/bin/bash
#first finds if an iso file has been mounted
DESC="
This checks if a local repo has been correctly configured or not
REPOCOUNT: The number of repos created
REPONAMES: A list of repo names to check for
"
#-
REPONAME=${REPONAME:="local"}
REPOCOUNT=${REPOCOUNT:=2}
#-
MOUNTPOINT=$(mount | awk '/iso/ {print $3}')
if [[ -z $MOUNTPOINT ]] 
then
	echo "iso has not been mounted"
	exit 1
fi
#next check if a local repo has been configured
REPOS=($(awk -F '//' '/baseurl=file:\/\// {print $2}' /etc/yum.repos.d/*))
if [[ -z ${REPOS[@]} ]] 
then
	echo "custom repo has not been configured correctly"
	exit 1
fi
#try to see if packages are accessible
if [[ $(yum --disablerepo="baseos appstream" list ) ]]
then	
	echo repo configured correctly 
else
	echo repo configured incorrectly
fi
