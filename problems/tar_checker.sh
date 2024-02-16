#!/bin/bash
DESC="
The tarball the user creates which should contain a verification file from the setup script
TARBALL: the location of the tarball to check
"
#-
TARBALL=${TARBALL:="/root/test.tar.gz"}
#-

#i'm unsure how to do this correctly, so for the mean time i'll do it simply

[[ -f $TARBALL ]] && tar -tf $TARBALL | grep ".verification" &> /dev/null && echo archive success || echo archive failure
