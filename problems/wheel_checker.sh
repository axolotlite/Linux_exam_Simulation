#!/bin/bash
#this checks if the wheel group has been enabled or not
#-
USER=${USER:="ahmed"}
#-
#check if user exists
id $USER &> /dev/null || ( echo "user $USER doesnt exist, exiting..." && exit 1 )
groups $USER | grep wheel &> /dev/null && echo "$USER is in wheel group" || echo "$USER is not in wheel group"
grep '^%wheel' /etc/sudoers &> /dev/null && echo "wheel setup correctly" || echo "wheel incorrectly set"
