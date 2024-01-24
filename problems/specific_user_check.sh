#!/bin/bash
#this should be added to user checker, later.
USER="alies"
USERID=1326
[[ $(id -u $USER) == $USERID ]] && echo $USER created with correct uid || echo user not created up to specifications
