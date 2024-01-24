#!/bin/bash
#checks if an ntp server has been configured
SERVER="classroom.iti_net"

chronyc sources -v |grep $SERVER &>/dev/null && echo ntp set successfully || echo ntp failed
