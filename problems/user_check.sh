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
	id "$user" &>/dev/null && echo user $user created || echo user $user was not created
done
#secondary group check
for user in ${SECONDARY_GROUP_USERS[@]}
do
	id -nG $user | grep $SECONDARY_GROUP &> /dev/null && echo $user in secondary group $SECONDARY_GROUP || echo $user is not in secondary group $SECONDARY_GROUP
done
#check nologin users
for user in ${NOLOGIN[@]}
do
	awk "/$user/ && /nologin/ {found=1} END {exit !found}" /etc/passwd && echo user $user has nologin shell || echo user $user has login shell
done
#check if users have passwords
for user in ${UPASSWD[@]}
do
#	echo $user
	passwd -S $user | grep locked &>/dev/null && echo $user doesnt have a password && continue 
	echo $DEFAULT_PASSWORD | sudo -u utility su - $user &> /dev/null && echo $user password was set correctly || echo $user password not configured correctly
done
