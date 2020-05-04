# CentOS 7 as gateway router

## Overview

This architecture is made up 2 CentOS/7 servers.
First one called **router** in Vagrant acts as gateway router for
second server **client**.

Modern **nmcli** and **firewall-cmd** tools are utilized to configure **router**
instead of manually changing **net.ipv4.ip_forward** kernel parameter.


## Requirements
- Vagrant
- VirtualBox

## Install

```bash
vagrant up
```

## Connect

### Connect to client
```bash
vagrant ssh client
```

### Become root

```bash
sudo -i
```

## Test connectivity

### Get the IPv4 address of the private interface(eth1)
```bash
ETH1_IP4=$(hostname -I | awk '{ print $2 }')
```

### Ping anywhere from the private interface
```bash
ping google.com -I ${ETH1_IP4}
```

## Clean up

### Run from your host machine

```bash
vagrant destroy
```
