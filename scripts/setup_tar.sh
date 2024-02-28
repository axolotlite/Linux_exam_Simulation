#!/bin/bash
DESC="
This script sets up tar archiving by creating a verification file in the archive directory

VERIFICATION_STRING: the string used inside the verification text file
ARCHIVE_DIR: the location of the verification file, where the archive should include
"
#-
VERIFICATION_STRING=${VERIFICATION_STRING:="success"}
ARCHIVE_DIR=${ARCHIVE_DIR:="/var/tmp/simple/directory/tree"}
ARCHIVE_FILE=${ARCHIVE_FILE:=".verification"}
#-
mkdir -p $ARCHIVE_DIR
echo "$VERIFICATION_STRING" > $ARCHIVE_DIR/$ARCHIVE_FILE
