#!/bin/bash
#this checks for cronjobs for users
USERS=("harry" "larry")
JOBS=('30 12 * * * /bin/echo "hello"')

for idx in ${!USERS[@]}
do
	user=${USERS[idx]}
	job=${JOBS[idx]}
	if [[ $(id $user 2> /dev/null) ]]; then
		[[ $(crontab -u $user -l) == "$job" ]] && echo job added to crontab || echo job has not been configured correctly
	else
		echo $user has not been created
	fi
done
