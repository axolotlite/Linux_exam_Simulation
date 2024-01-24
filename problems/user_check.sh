#!/bin/bash
#these are the given data
USERS=(harry natasha sarah temo)
PRIMARYGROUPS=(harry natasha sarah)
SECONDARY_GROUP_USERS=(harry natasha)
SECONDARY_GROUP="admin"
NOLOGIN=(sarah)
UPASSWD=()
#check if users have been created
for user in ${USERS[@]}
do
#first check if user has been created
	id "$user" &>/dev/null && echo user $user created && UPASSWD+=("$user") || echo user $user was not created
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
echo ${UPASSWD[@]}
for user in ${UPASSWD[@]}
do
	passwd -S $user | grep locked &>/dev/null && echo $user has no password || echo $user has password
done
