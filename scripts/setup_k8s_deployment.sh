#!/bin/bash

#-
FILEPATH=${FILEPATH:="~/.k8s/front-end.yaml"}

#-

kubectl apply -f $FILEPATH
