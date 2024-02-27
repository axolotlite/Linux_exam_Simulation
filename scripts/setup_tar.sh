#!/bin/bash
#This script sets up tar archiving by creating a verification file in the archive directory
VERIFICATION_STRING="success"
ARCHIVE_DIR="/var/tmp/simple/directory/tree/.verification"
mkdir -p $ARCHIVE_DIR
echo "$VERIFICATION_STRING" > $ARCHIVE_DIR
