#!/bin/bash
#-
KUBELET_VERSION=${KUBELET_VERSION:="1.29.0"}
KUBEADM_VERSION=${KUBEADM_VERSION:="1.29.0"}
KUBE_CONTROLLER_VERSION=${KUBE_CONTROLLER_VERSION:="1.29.0"}
KUBE_APISERVER_VERSION=${KUBE_APISERVER_VERSION:="1.29.0"}
KUBE_SCHEDULER_VERSION=${KUBE_SCHEDULER_VERSION:="1.29.0"}
#-

kubelet_version="$(kubelet --version | awk '{print  $NF}')"
kubeadm_version="$(kubeadm version -o yaml | grep gitVersion | awk '{print  $NF}')"
kube_controller_version="$(cat /etc/kubernetes/manifests/kube-controller-manager.yaml | grep image: | awk -F: '{print  $NF}')"
kube_apiserver_version="$(cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep image: | awk -F: '{print  $NF}')"
kube_scheduler_version="$(cat /etc/kubernetes/manifests/kube-scheduler.yaml | grep image: | awk -F: '{print  $NF}')"

app=("kubelet" "kubeadm" "kube-controller-pod" "kube-apiserver-pod" "kube-scheduler-pod")
versions=( "$kubelet_version" "$kubeadm_version" "$kube_controller_version" "$kube_apiserver_version" "$kube_scheduler_version" )
VERSIONS=( "$KUBELET_VERSION" "$KUBEADM_VERSION" "$KUBE_CONTROLLER_VERSION" "$KUBE_APISERVER_VERSION" "$KUBE_SCHEDULER_VERSION" )
for idx in "${!versions[@]}"
do
	if [[ ${versions[$idx]} == ${VERSIONS[$idx]} ]]
	then
		echo "${app[$idx]} is now at the desired version ${VERSIONS[$idx]}"
	else
		echo "${app[$idx]} is at version ${versions[$idx]} instead of ${VERSIONS[$idx]}"
	fi
done
