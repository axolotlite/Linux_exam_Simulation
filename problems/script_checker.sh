#!/bin/bash
#this will call the user script and check if it's the same as our output
VERIFICATION_DIR="/root/.myfiles"
CHECK_DIR="/root/myfiles"
mkdir $CHECK_DIR
RUN=$(find /usr/share/ -type f -size -1M -exec cp {} $VERIFICATION_DIR \;)
SCRIPT="/usr/local/bin/mysearch.sh"
#run the script
bash -exec $SCRIPT
#check if both outputs are the same
diff -qr $VERIFICATION_DIR $CHECK_DIR && echo script executed successfully || echo script failed
