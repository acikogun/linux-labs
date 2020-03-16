#!/bin/bash

source /etc/profile.d/globals.sh

cat > /etc/hosts << EOM
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
${HTTPD1_PRIV} ${HTTPD1_HOSTNAME} httpd-1
EOM

yum install -y httpd

systemctl start httpd
systemctl enable httpd

echo "${HTTPD1_PRIV} ${HTTPD1_HOSTNAME}" > /var/www/html/index.html

firewall-cmd --add-service=http
firewall-cmd --add-service=http --permanent
