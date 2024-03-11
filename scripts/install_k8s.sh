#!/bin/bash
#HOSTNAME="$(hostnamectl | awk '/Operating/ {print $3}').worker"
#echo $HOSTNAME | sudo tee /etc/hostname
#sudo hostnamectl set-hostname $HOSTNAME
#-
REPOFILE=${REPOFILE:="$HOME/.files/k8s/k8s.repo"}
FIREWALL_CONFIGS=${FIREWALL_CONFIGS:="$HOME/.files/k8s/k8s_worker.xml"}
FORK=${FORK:="true"}
#-
#install the repos
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf config-manager --add-repo file://${REPOFILE}
#update the cache
dnf makecache

dnf install -y containerd.io systemd-resolved
mv /etc/containerd/config.toml /etc/containerd/config.toml.bak

containerd config default | sed 's/SystemdCgroup =.*/SystemdCgroup = true/; write /etc/containerd/config.toml' -n

systemctl enable --now containerd.service

echo -e "overlay\nbr_netfilter" > /etc/modules-load.d/k8s.conf

modprobe overlay
modprobe br_netfilter
#allow firewalld-ports
mv $FIREWALL_CONFIGS /usr/lib/firewalld/services/
restorecon /usr/lib/firewalld/services/k8s_worker.xml
sudo firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --reload
firewall-cmd --add-service k8s_worker --permanent
firewall-cmd --reload
#allow port forwarding
echo -e "net.ipv4.ip_forward = 1\nnet.bridge.bridge-nf-call-ip6tables = 1\nnet.bridge.bridge-nf-call-iptables = 1" > /etc/sysctl.d/k8s.conf
sysctl --system

#disable swap
swapoff -a
sed -e '/swap/s/^/#/g' -i /etc/fstab

#insall k8s
dnf install -y kubeadm --disableexcludes=kubernetes
systemctl enable systemd-resolved --now
systemctl enable kubelet --now
