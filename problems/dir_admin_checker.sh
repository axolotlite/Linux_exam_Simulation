#!/bin/bash
DIRECTORY="/common/admin"
OWNER="admin"
PERMISSION="^(2|6)770"
#check if the directories have been created
if [[ -d $DIRECTORY ]]; then
	echo "it exists"
	#check if the ownership is correct
	[[ $(stat -c "%G" $DIRECTORY) == $OWNER ]] && echo "correct owner: $OWNER"
	#check if it's the right permission, whether you applied the sticky to user or not is irrelevant
	[[ $(stat -c '%a' $DIRECTORY ) =~ $PERMISSION ]] && echo "correct permissions set: $PERMISSION"
else
	echo "/common/admin not found"
fi
