#!/bin/bash
#compare the current swap with the default swap
DESC="
This problem checks for the difference between the swap before and after user intervention
MIN_DIFF: the minimum amount of swap the user should add
SWAPINFO: the file containing the original swap created by the setup script
"
#-
MIN_DIFF=${MIN_DIFF:=512}
SWAPINFO=${SWAPINFO:="/root/.swapinfo"}
#-
PREV_SWAP=$(cat $SWAPINFO)
CURR_SWAP=$(free --mega | awk '/Swap/ {print $2}')
if (( PREV_SWAP + MIN_DIFF - 2 <= CURR_SWAP )); then
	echo "swap created according to specifications"
else
	echo "swap is not enough"
fi
