#!/bin/bash
USER="sarah"
FILE="$HOME/.filenames"
FIND_DIR="/root/find.user"
TOTAL=$(cat $FILE | wc -l)
COUNT=0
#finds all the randomly created files belonging to user
for filename in $(cat $FILE)
do
	ls $FIND_DIR | grep $filename &> /dev/null && ((COUNT++))
done
echo found $COUNT/$TOTAL files
