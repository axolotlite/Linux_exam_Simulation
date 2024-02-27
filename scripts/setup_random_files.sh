#!/bin/bash
#
DESC="
This creates random files and places them in a random directory while recording the file names

USER: the owner of these files
FILE_COUNT: the number of these files
RECORD_DIR: the place where the filenames are stored
"
#-
USER=${USER:="farah"}
FILE_COUNT=${FILE_COUNT:=10}
RECORD_DIR=${RECORD_DIR:="$HOME/.filenames"}
#-
id $USER &> /dev/null || useradd -M $USER
find / -type d -mount -print0 2> /dev/null |
       shuf -zn $FILE_COUNT |
               while IFS= read -r -d "" dir; do
                       file=$(sudo -u $USER mktemp)
                       echo $file | awk -F '/' '{print $NF}' >> $RECORD_DIR
                       mv $file "$dir" && echo "moved file to $dir"
               done
