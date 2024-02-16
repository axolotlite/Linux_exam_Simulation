#!/bin/bash
DESC="
This checks if the user set the hostname correctly
HOSTNAME: the hostname the user should've set
"
#-
HOSTNAME=${HOSTNAME:="khaldoom"}
#-

[[ $(hostname) =~ "$HOSTNAME" ]] && echo "hostname set correctly" || echo "hostname set incorrectly"
