#!/bin/bash
#first finds if an iso file has been mounted
DESC="
This checks if a local repo has been correctly configured or not
REPOCOUNT: The number of repos created
REPONAMES: A list of repo names to check for
"
#-
#[ -n $REPONAME ] || REPONAME=$1
REPOCOUNT=${REPOCOUNT:=2}
#-
MOUNTPOINT=$(mount | awk '/iso/ {print $3}')
[[ -z $MOUNTPOINT ]] && (echo "iso has not been mounted" && exit 1)
#next check if a local repo has been configured
REPOS=($(awk -F '//' '/baseurl=file:\/\// {print $2}' /etc/yum.repos.d/*))
[[ -z ${REPOS[@]} ]] && (echo "custom repo has not been configured correctly" && exit 1)
#try to see if packages are accessible
yum --disablerepo="baseos appstream" list &> /dev/null && echo repo configured correctly || echo repo configured incorrectly
