#!/bin/bash
#-
RESOURCE=${RESOURCE:="nodes"}
OBJECTNAME=${OBJECTNAME:="worker1"}
LABELS=${LABELS:="disk=ssd memory=ddr5"}
#-

kubectl label $RESOURCE $OBJECTNAME $LABELS
