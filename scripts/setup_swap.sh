#!/bin/bash
DESC="
This sets up the default swap of the vm, in case the user increases it
SWAPINFO: this is the location of the previous size of the swap
"
#-
SWAPINFO=${SWAPINFO:="/root/.swapinfo"}
#-
free --mega | awk '/Swap/ {print $2}' > $SWAPINFO
