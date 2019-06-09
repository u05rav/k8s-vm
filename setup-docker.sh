#!/bin/bash

apt-get -y remove docker docker-engine docker.io containerd runc
apt-get -y update
apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get -y update
apt-get -y install docker-ce docker-ce-cli containerd.io

cp /vagrant/docker.service /lib/systemd/system/

systemctl daemon-reload
systemctl restart docker

docker -H localhost:2375 run hello-world
