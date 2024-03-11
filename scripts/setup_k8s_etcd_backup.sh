#!/bin/bash
#-
DB_LOCATION=${DB_LOCATION:="/opt/backup.db"}
VERIFICATION_FILE=${VERIFICATION_FILE:="$HOME/.missing_pod"}
PODNAME=${PODNAME:="missing-pod"}
NAMESPACE=${NAMESPACE:="missing"}
FORK=${FORK:="false"}
#-
while [[ ! -f "$DB_LOCATION" ]]
do
        sleep 1
	echo "waiting for $DB_LOCATION"
done
touch $VERIFICATION_FILE
kubectl create ns $NAMESPACE
kubectl run $PODNAME --image=nginx -n $NAMESPACE --restart Always -- sleep 3600
echo "what the hell"
