#!/bin/bash
#compare the current swap with the default swap
MIN_DIFF=512
PREV_SWAP=$(cat /root/.swapinfo)
CURR_SWAP=$(free --mega | awk '/Swap/ {print $2}')
if (( PREV_SWAP + MIN_DIFF - 2 <= CURR_SWAP )); then
	echo swap created according to specifications
else
	echo swap is not enough
fi
