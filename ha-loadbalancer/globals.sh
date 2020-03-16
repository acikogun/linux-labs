#!/bin/bash

export HAPROXY1_PUB="192.168.1.13"
export HAPROXY2_PUB="192.168.1.14"

export HTTPD1_PRIV="192.168.50.11"
export HTTPD2_PRIV="192.168.50.12"

export HTTPD1_HOSTNAME="httpd-1.lab.example.com"
export HTTPD2_HOSTNAME="httpd-2.lab.example.com"

export HAPROXY1_HOSTNAME="haproxy-1.lab.example.com"
export HAPROXY2_HOSTNAME="haproxy-2.lab.example.com"

# Allocate a virtual ip address from the same network (eth0)
export PUBLIC_IP=$(hostname -I | awk '{ print $2 }')
export NETWORK_ADDRESS=$(echo $PUBLIC_IP | cut -d '.' -f 1-3)
export VIRTUAL_IP_ADDRESS="${NETWORK_ADDRESS}.100"
