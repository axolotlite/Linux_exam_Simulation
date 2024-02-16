#!/bin/bash
#

USER="farah"
FILE_COUNT=10
RECORD_DIR="$HOME/.filenames"
id $USER &> /dev/null || useradd -M $USER
find / -type d -mount -print0 2> /dev/null |
       shuf -zn $FILE_COUNT |
               while IFS= read -r -d "" dir; do
                       file=$(sudo -u $USER mktemp)
                       echo $file | awk -F '/' '{print $NF}' >> $RECORD_DIR
                       mv $file "$dir" && echo "moved file to $dir"
               done
