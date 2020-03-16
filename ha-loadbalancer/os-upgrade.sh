#!/bin/bash

yum update -y

yum install -y policycoreutils-python \
               vim curl bash-completion \
               net-tools tcpdump lsof

# Enable firewalld that is not enabled on centos/7 box by default
systemctl enable firewalld
