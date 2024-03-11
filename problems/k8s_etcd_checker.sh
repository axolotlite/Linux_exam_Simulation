#!/bin/bash
#-
DB_LOCATION=${DB_LOCATION:="/opt/backup.db"}
VERIFICATION_FILE=${VERIFICATION_FILE:="$HOME/.missing_pod"}
PODNAME=${PODNAME:="missing-pod"}
NAMESPACE=${NAMESPACE:="missing"}
#-
if [[ -f $DB_LOCATION ]]
then
        if [[ -f $VERIFICATION_FILE ]]
        then
                echo "backup successfully created"
        else
                echo "db backup was not created at $VERIFICATION_FILE"
        fi
        if [[ ! $("$HOME/.missing_pod" &> /dev/null) ]]
        then
                echo "$PODNAME wasn't found in namespace:$NAMESPACE, which indicates a successfull rollback!"
        else
                echo "$PODNAME was found in namespace:$NAMESPACE, are you sure you performed a rollback?"
        fi
else
        echo "db file was not found in $DB_LOCATION"
fi
