#!/bin/bash

cat > ${REPO_FILE} << EOM
[base]
name=CentOS - Base
baseurl=http://${LOCAL_REPO_IP}/centos/base/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[updates]
name=CentOS - Updates
baseurl=http://${LOCAL_REPO_IP}/centos/updates/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[extras]
name=CentOS - Extras
baseurl=http://${LOCAL_REPO_IP}/centos/extras/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[centosplus]
name=CentOS-$releasever - Plus
baseurl=http://${LOCAL_REPO_IP}/centos/centosplus/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

EOM

rm -rf /var/cache/yum/

yum repolist
