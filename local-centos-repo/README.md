# CentOS 7 as a local rpm repository mirror

## Overview

If you have a lot of systems you may want to consider setting up
a local mirror.

You will have two main advantages by adopting this architecture:
- Bandwidth. Download once, use many times from many servers instead of downloading
  same packages from all servers.
- Speed. Set up this in your internal network and this is your fastest mirror.


## Notes

- This architecture is made up 2 CentOS/7 servers.
  First one called **local-repo** acts as local mirror for
  **base**, **updates**, **extras**, **centosplus** repositories for CentOS/7(x86_64)

- Second server **client** is configured to use **local-repo** by default.

- A daily cron job is created on **local-repo** to sync repos from external mirrors.

- **reposync** and **create** tools are utilized to sync and create local mirrors.

- This is just a showcase for CentOS/7(x86_64). You should consider other releases and archs too.

- It will download about 10GBs and may take a long time.

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

## Test local-repo

### List repos
```bash
yum repolist
```

### Upgrade system
```bash
yum update -y
```

### Install a package
```bash
yum install -y java
```

### Test groups
```bash
yum group list
```

```bash
yum group install -y "Development Tools"
```

## Clean up

### Run from your host machine

```bash
vagrant destroy
```
