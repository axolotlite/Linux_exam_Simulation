#!/bin/bash
#this checks for cronjobs for users
#Ive decided to place the users and jobs in the same array, 
DESC="
This problem checks for users and their jobs
USER_JOBS:
	You first specify the user, then his crontab options, the crontab options are seperated by a semi-colon
	format:
		user: * * * * * /bin/command 'string';* * * * * /bin/other_command 'string';etc...
"
#-
USER_JOBS=${USER_JOBS:="harry:30 12 * * * /bin/echo 'hello';40 10 1 * * /bin/echo 'last'"}
#-
#rewritten with comments due to my fear if this getting too complex
#
match_time () {
	IFS=" " read -r min1 hr1 day1 mon1 week1 <<< "$1"
	IFS=" " read -r min2 hr2 day2 mon2 week2 <<< "$2"
	#comparison time
	[[ $min1 == $min2 ]] && echo "min correctly set" || echo "min set incorrectly" && return 
	[[ $hr1 == $hr2 ]] && echo "hours correctly set" || echo "hours set incorrectly" && return 
	[[ $day1 == $day2 ]] && echo "day correctly set" || echo "day set incorrectly" && return 
	[[ $mon1 == $mon2 ]] && echo "month correctly set" || echo "month set incorrectly" && return 
	[[ $week1 == $week2 ]] && echo "week correctly set" || echo "week set incorrectly" && return 
}
match_job () {
#this may not actually work, as the user implementation may be different
#this is a bit more difficult than matching time, two possible solutions are

#match the strings
#match the output of the function
	out1=$(eval $1)
	out2=$(eval $2)
	[[ $out1 == $out2 ]] && echo "script output correctly" || echo -e "script output faulty.\nout1: $out1\nout2: $out2"
}
#first, we iterate through the users we're supposed to test their crontabs
for element in "${USERS_JOBS[@]}"
do
#	echo "$element"
	#get this users jobs using newline as a delimeter for the arrays element
	IFS=: read -r user job_list <<< "$element"
	IFS=$'\n' user_jobs=($(crontab -u $user -l))
	IFS=';' job_list=($job_list)
#	echo "job_list: $job_list"
	#get the user and his jobs to test
#	echo "$element"
	#now we compare the user jobs with jobs listed above
	for job in "${user_jobs[@]}"
	do
		IFS=/ read -r timing function <<< $job
#		echo -e "timer: $timing\nfunction: /$function"
#		IFS=" " read -r MIN HOUR DAY MONTH WEEK <<< $timing
#		echo -e "min: $MIN\nhour: $HOUR\nday: $DAY\nmonth: $MONTH\nweek: $week"
		for job2 in "${job_list[@]}"
		do
			echo -e "comparing:\n$job\n$job2"
			IFS=/ read -r timing2 function2 <<< $job2
			match_time $timing $timing2
			match_job "/$function" "/$function2"
		done
	done
done

