# Kerberized NFS Server

## Overview

This is a NFS server-client architecture with Kerberos authentication.
Kerberos authentication is a powerful security layer. It is handled by
FreeIPA server in this solution.


- [Kerberized NFS Server](#kerberized-nfs-server)
  - [Overview](#overview)
  - [Notes](#notes)
  - [Architecture](#architecture)
  - [Requirements](#requirements)
  - [Install](#install)
  - [Connect](#connect)
  - [Test kerberized NFS share](#test-kerberized-nfs-share)
    - [Connect to NFS client](#connect-to-nfs-client)
    - [Become root](#become-root)
    - [Print nfs username and password](#print-nfs-username-and-password)
    - [Switch to nfs user](#switch-to-nfs-user)
    - [Try to access shared folder](#try-to-access-shared-folder)
    - [Login to Kerberos (Change password if necessary)](#login-to-kerberos-change-password-if-necessary)
    - [Print kerberos session](#print-kerberos-session)
    - [Try to access shared folder again](#try-to-access-shared-folder-again)
    - [Create a file](#create-a-file)
    - [Logout from Kerberos](#logout-from-kerberos)
  - [Clean up](#clean-up)
    - [Run from your host machine](#run-from-your-host-machine)



## Notes

- All components are automatically installed with via Vagrant.


- You can also manually install by following up script files.
(**`ipa-server.sh`**,**`nfs-server.sh`**, **`nfs-client.sh`**)


- Settings are placed in **`globals.sh`** file.


- **generic/centos7** box is used instead of official centos/7 vagrant box since it is up-to-date and well maintained.

## Architecture

The architecture is made up of 3 main servers:

1.  A [FreeIPA Server](https://www.freeipa.org/page/Main_Page) Integrated security information
    management solution combining Linux (Fedora), 389 Directory Server, MIT Kerberos, NTP, DNS,
    Dogtag certificate system, SSSD and others.
    - **ipa-server** in Vagrant
2.  An NFS server with Kerberos authentication, enrolled in FreeIPA Server.
    - **nfs-server** in Vagrant
3.  An NFS client to mount and test kerberized share.
    - **nfs-client** in Vagrant

## Requirements
- Vagrant
- VirtualBox
- At least 6GB RAM on your host machine

## Install

```bash
vagrant up
```

**Warning:** centos/7 boxes upgraded before installing software packages. So it might take a long time.

Environment variables in globals.sh are exported to all servers.

## Connect

```bash
# Connect to FreeIPA server
vagrant ssh ipa-server

# Connect to NFS server
vagrant ssh nfs-server

# Connect to NFS client
vagrant ssh nfs-client
```

## Test kerberized NFS share

### Connect to NFS client
```bash
vagrant ssh nfs-client
```

### Become root
```bash
sudo -i
```

### Print nfs username and password
```bash
echo $NFS_USERNAME
echo $NFS_USERPASS
```

### Switch to nfs user
```bash
su - $NFS_USERNAME
```

### Try to access shared folder
- It is not permitted unless you authenticated with Kerberos.
- That's the point!

```bash
cd $NFS_MOUNT
```

### Login to Kerberos (Change password if necessary)
```bash
echo $NFS_USERPASS | kinit
```

### Print kerberos session
```bash
klist
```

### Try to access shared folder again

```bash
cd $NFS_MOUNT
```

### Create a file
```bash
touch hello.txt
```

### Logout from Kerberos
```bash
kdestroy -A
```

## Clean up

### Run from your host machine

```bash
vagrant destroy
```

**Warning:** You will still able to access the shared folder after logging out (kdestroy -A) from Kerberos.

You might be wonder why. It is explanied [here](http://www.citi.umich.edu/projects/nfsv4/linux/faq/).

> I am accessing an NFSv4 mount via Kerberos and then I do a kdestroy, but I am still able to access the NFS data. Why?


> The kernel code caches the gssapi context that was negotiated using the Kerberos credentials. Destroying the credentials does not destroy the context in the kernel. We plan to change this behavior when moving to use the new key ring kernel support to store credentials and contexts.
