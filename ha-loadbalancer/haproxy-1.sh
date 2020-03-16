#!/bin/bash

source /etc/profile.d/globals.sh

# Allow binding, listening non-exist virtual ip address
echo "net.ipv4.ip_nonlocal_bind=1" >> /etc/sysctl.conf
sysctl -p

cat > /etc/hosts << EOM
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
${HTTPD1_PRIV} ${HTTPD1_HOSTNAME} httpd-1
${HTTPD1_PRIV} ${HTTPD2_HOSTNAME} httpd-2
${HAPROXY1_PUB} ${HAPROXY1_HOSTNAME} haproxy-1
${HAPROXY2_PUB} ${HAPROXY2_HOSTNAME} haproxy-2

EOM

yum install -y keepalived
yum install -y haproxy

systemctl enable keepalived
systemctl enable haproxy

cat > /etc/keepalived/keepalived.conf << EOM
vrrp_script chk_haproxy {
  script "pgrep haproxy"
  interval 2
  weight 2
}

vrrp_instance VI_1 {
  interface eth1
  state MASTER
  virtual_router_id 51
  priority 101
  advert_int 2

  unicast_src_ip ${HAPROXY1_PUB}

  unicast_peer {
    ${HAPROXY2_PUB}
  }

  authentication {
    auth_type PASS
    auth_pass 0103
  }

  virtual_ipaddress {
    ${VIRTUAL_IP_ADDRESS}
  }

  track_script {
    chk_haproxy
  }
}

EOM

cat > /etc/haproxy/haproxy.cfg << EOM
defaults
    log     global
    mode    http
    option  httplog
    option  dontlognull
    timeout connect 5000
    timeout client  50000
    timeout server  50000

frontend web
    bind ${VIRTUAL_IP_ADDRESS}:80
    mode http
    default_backend httpdpool

backend httpdpool
    balance roundrobin
    option forwardfor
    http-request set-header X-Forwarded-Port %[dst_port]
    option httpchk HEAD / HTTP/1.1\r\nHost:localhost
    server httpd-1 ${HTTPD1_PRIV}:80 check
    server httpd-2 ${HTTPD2_PRIV}:80 check

EOM

systemctl start keepalived
systemctl start haproxy

firewall-cmd --add-service=http
firewall-cmd --add-service=http --permanent
