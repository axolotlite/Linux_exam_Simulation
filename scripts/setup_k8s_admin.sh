#!/bin/bash
#-
USER=${USER:="root"}
#-
if [[ "$USER" == "root" ]] 
then
	mkdir $HOME/.kube
	cp -ri /etc/kubernetes/admin.conf ~/.kube/config
elif [[ $(id $USER &> /dev/null) ]]
then
	mkdir /home/$USER/.kube
	cp -ri /etc/kubernetes/admin.conf /home/$USER/.kube/config
fi
