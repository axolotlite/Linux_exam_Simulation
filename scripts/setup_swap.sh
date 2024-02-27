#!/bin/bash
#This sets up the default swap of the vm, in case the user increases it
#-
SWAPINFO=${SWAPINFO:="/root/.swapinfo"}
#-
free --mega | awk '/Swap/ {print $2}' >> $SWAPINFO
