#!/bin/bash

#DEPLOYMENT=${DEPLOYMENT:="front-end"}
#IMAGE=${IMAGE:="nginx"}
#PORT=${PORT:=80}
#TARGET_PORT=${TARGET_PORT:=80}
#SVC_NAME=${SVC_NAME:="front-end-svc"}
#-
VALUE=${VALUE:="nginx"}
RESOURCE=${RESOURCE:="deployment"}
OBJECTNAME=${OBJECTNAME:="front-end"}
JSONPATH=${JSONPATH:="{.spec.template.spec.containers[*].image}"}
PARAMS=${PARAMS:="-n default"}
SMSG=${SMSG:="success message"}
FMSG=${FMSG:="failed message"}
#-
image_query='{.spec.template.spec.containers[*].image}'
containerPort='{.spec.template.spec.containers[*].ports[*].containerPort}'
svc_port="{.spec.ports[?(@.port==$PORT)].targetPort}"
svc_type="{$.spec.type}"
kquery() {
	echo $(kubectl get $RESOURCE $OBJECTNAME -o jsonpath=$JSONPATH $PARAMS)
}
kchecker(){
	value=$1
	query=$2
	if [[ "$1" == "$2" ]]
	then
		echo "$SMSG"
	else
		echo "$FMSG"
	fi
}
kchecker "$VALUE" "$(kquery)"

