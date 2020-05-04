#!/bin/bash

source /etc/profile.d/globals.sh

ETH1_IP4=$(hostname -I | awk '{ print $2 }')

echo
echo
echo
echo "Testing connectivity from ${ETH1_IP4}"
ping -c 4 google.com -I ${ETH1_IP4}
