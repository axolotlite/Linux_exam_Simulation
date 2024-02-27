#!/bin/bash
DESC="
This is a test setup script used to verify the deployment script
"
#-
MESSAGE=${MESSAGE:="Hello There, I've been successfully deployed"}
LOCATION=${LOCATION:="/root/message.txt"}
#-

echo $MESSAGE > $LOCATION
