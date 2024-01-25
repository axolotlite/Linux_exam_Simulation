#!/bin/bash
#checks if an ntp server has been configured
SERVER="$CLASSROOM_HOSTNAME"

chronyc sources -v |grep $SERVER &>/dev/null && echo ntp set successfully || echo ntp failed
