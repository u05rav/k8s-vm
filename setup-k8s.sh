#!/bin/bash

if [ $# -ne 1 ]
then
	echo "usage: $0 <create|join>"
fi

apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

kubeadm reset -f

if [ "$1" == "create" ]
then
	IP=$(ip addr show enp0s8 | grep 'inet ' | cut -d\  -f6 | cut -d/ -f1)
	echo IP=$IP		

	kubeadm init --apiserver-advertise-address=$IP \
		     --apiserver-cert-extra-sans="127.0.0.1" \
		     --pod-network-cidr="10.244.0.0/16" | tee /vagrant/create.log

	cp /etc/kubernetes/admin.conf /vagrant/
	sed -i '/server:/c\    server: https://127.0.0.1:6443' /vagrant/admin.conf

	export KUBECONFIG=/etc/kubernetes/admin.conf

	kubectl apply -f /vagrant/kube-flannel.yml

	kubectl taint node $HOSTNAME node-role.kubernetes.io/master:NoSchedule-
else
	JOIN_COMMAND=$(cat /vagrant/create.log | grep -A 2 "kubeadm join" | tr -d '\')
	echo $JOIN_COMMAND
	$JOIN_COMMAND
fi
