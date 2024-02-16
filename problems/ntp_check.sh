#!/bin/bash
DESC="
This problems checks if an ntp server has been configured
SERVER: The server name to check from the chronyc server
"
#-
SERVER=${SERVER:="10.10.10.150"}
#-

chronyc sources -v |grep $SERVER &>/dev/null && echo ntp set successfully || echo ntp failed
