#!/bin/bash
#This script takes a source file and sshs into the host to grade / check the answers
PROBLEMS_DIR="problems/"
HOSTS="environments/hosts.env"
KEY="credentials/utility"
USER="root"
if [ -n "$1" ]; then 
	source $1
	source $HOSTS
	#first lab 1
	for problem in "${LAB_A_PROBLEMS[@]}"
	do
		script=$PROBLEMS_DIR$problem 
		[[ -f $script ]] && echo "$problem file exists..." || continue
		read -n 1 -p "execute?"
		cat $HOSTS $script | ssh -i $KEY $USER@$LAB_A_ADDRESS "bash -s"
	done
	#then lab 2
	for problem in "${LAB_B_PROBLEMS[@]}"
	do
		script=$PROBLEMS_DIR$problem 
		[[ -f $script ]] && echo "$problem file exists..." || continue
		read -n 1 -p "execute?"
		cat $HOSTS $script | ssh -i $KEY $USER@$LAB_B_ADDRESS "bash -s"
	done
else
	echo "sepcify an exam file"
fi
