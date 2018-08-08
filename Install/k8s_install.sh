#!/bin/bash

### ***************************************************************************
#
# This script checks if a database container is healthy based on cluster type.
# The purpose of this script is to make Docker capable of monitoring different
# database cluster type properly.
# This script will just return exit 0 (OK) or 1 (NOT OK).
#
# Dependencies:
# - dns, apt, git, docker, kubernetes, curl
#
# Made(Creator)  Unknown
# Contact:       Unknown
# Created:       Unknown
# Last modified: August 9, 2018
# Passed(tested) for:
#   - macOS 10 to 10.13.5
#   - Ubuntu 14 to 17                                                                                                                                                                                                               
#
# Major used at: Kubernetes, Docker
#
### **************************************************************************

apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
# Install docker if you don't have it already.
# apt-get install -y docker.io
apt-get install -y kubelet kubeadm kubectl kubernetes-cni
