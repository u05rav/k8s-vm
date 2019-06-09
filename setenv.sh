#!/bin/bash

export DOCKER_HOST=127.0.0.1:2375
export KUBECONFIG=$(readlink -f ./admin.conf)
