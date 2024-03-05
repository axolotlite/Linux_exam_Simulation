#!/bin/bash
#these are the given data
DESC="

"
#-
UTILITY_USER=${UTILITY_USER:="utility"}
USERS=${USERS:="harry natasha sarah temo"}
PRIMARYGROUPS=${PRIMARYGROUPS:="harry natasha sarah"}
SECONDARY_GROUP_USERS=${SECONDARY_GROUP_USERS:="harry natasha"}
SECONDARY_GROUP=${SECONDARY_GROUP:="admin"}
NOLOGIN=${NOLOGIN:="sarah"}
UPASSWD=${UPASSWD:="harry natasha"}
DEFAULT_PASSWORD=${DEFAULT_PASSWORD:="password"}
#-
#check if users have been created
for user in ${USERS[@]}
do
#first check if user has been created
	if [[ $(id "$user" ) ]] 
	then
		echo "user $user created"
	else
		echo "user $user was not created"
	fi
done
#secondary group check
for user in ${SECONDARY_GROUP_USERS[@]}
do
	if [[ $(id -nG $user | grep $SECONDARY_GROUP ) ]]
	then
	       	echo "$user in secondary group $SECONDARY_GROUP"
	else
		echo "$user is not in secondary group $SECONDARY_GROUP"
	fi
done
#check nologin users
for user in ${NOLOGIN[@]}
do
	#if [[ $(awk "/$user/ && /nologin/ {found=1} END {exit !found}" /etc/passwd) ]]
	if [[ $(grep "$user" /etc/passwd | grep "nologin") ]]
	then
		echo "user $user has nologin shell"
	else
		echo "user $user has login shell"
	fi
done
#check if users have passwords
for user in ${UPASSWD[@]}
do
#	echo $user
	if [[ $(passwd -S $user | grep locked ) ]] 
	then
		echo "$user doesnt have a password"
		continue
	fi
	useradd -M $UTILITY_USER &> /dev/null
	if [[ $(echo $DEFAULT_PASSWORD | sudo -u $UTILITY_USER su - $user ) ]]
	then
		echo "$user password was set correctly"
	else
		echo "$user password not configured correctly"
	fi
	userdel $UTILITY_USER &> /dev/null
done
