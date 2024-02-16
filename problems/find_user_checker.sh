#!/bin/bash
#
DESC="
This problem checks for files created by a specific user and scattered randomly across the system
FILE: The file containing the list of files to check for
FIND_DIR: The directory the user is instructed to copy those files to
"
#-
FILE=${FILE:="$HOME/.filenames"}
FIND_DIR=${FIND_DIR:="$HOME/.find.user"}
#-
TOTAL=$(cat $FILE | wc -l)
COUNT=0
#finds all the randomly created files belonging to user
for filename in $(cat $FILE)
do
	ls $FIND_DIR | grep $filename &> /dev/null && ((COUNT++))
done
echo found $COUNT/$TOTAL files
