#!/bin/bash
DESC="
This will call the user script and check if it's the same as our output
VERIFICATION_DIR: the directory where the setup script saves its output to
CHECK_DIR: the directory where the user outputs his script to
RUN: a custom script to save the output for comparing between user output this its output
"
#-
VERIFICATION_DIR=${VERIFICATION_DIR:="/root/.myfiles"}
CHECK_DIR=${CHECK_DIR:="/root/myfiles"}
RUN=${RUN:="find /usr/share/ -type f -size -1M -exec cp {} $VERIFICATION_DIR \;"}
#-
mkdir $CHECK_DIR
#RUN=$
$RUN
SCRIPT="/usr/local/bin/mysearch.sh"
#run the script
bash -exec $SCRIPT
#check if both outputs are the same
diff -qr $VERIFICATION_DIR $CHECK_DIR && echo script executed successfully || echo script failed
