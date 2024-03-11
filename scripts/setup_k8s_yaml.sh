#!/bin/bash

#-
LOCALPATH=${LOCALPATH:="~/.files/k8s/front-end.yaml"}

#-

kubectl apply -f $LOCALPATH
