#!/bin/bash
#-
METHOD=${METHOD:="0"}
VALUE=${VALUE:="6553"}
#-


case $METHOD in
	0)
		sed  "s/6443/$VALUE/" -i /etc/kubernetes/kubelet.conf
		;;
	1)
		echo placeholder
		;;
	2)
		echo placeholder
		;;
esac
systemctl restart kubelet
