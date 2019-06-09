#!/bin/bash

apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

kubeadm reset -f
kubeadm init --apiserver-advertise-address="0.0.0.0" \
	     --apiserver-cert-extra-sans="127.0.0.1" \
	     --pod-network-cidr="10.244.0.0/16"

cp /etc/kubernetes/admin.conf /vagrant/
sed -i '/server:/c\    server: https://127.0.0.1:6443' /vagrant/admin.conf

export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl apply -f /vagrant/kube-flannel.yml

kubectl taint node $HOSTNAME node-role.kubernetes.io/master:NoSchedule-
