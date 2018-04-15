# Security

## Overview

Commands
- List all Zone: `firewall-cmd --list-all-zones`
- List Zone Names: `firewall-cmd --list-all-zones | grep ^[a-z]`
- List Active Zone: `firewall-cmd --list-all`
- Get Default Zone: `firewall-cmd --get-default-zone`
- List Specified Zone: `firewall-cmd --list-all --zone=work`


Configuration Files
- Default: `/lib/firewalld`
- User Generated: `/etc/firewalld`


Don't use block and trusted zones.  They ignore any rich rules.


## Install Web Server

<pre>
yum -y install httpd
systemctl enable httpd
systemctl start httpd
echo "s1" > /var/www/html/index.html
</pre>


## Allow Access From Specified IP range

<pre>
firewall-cmd --permanent --add-source=172.16.1.0/24 --zone=internal
firewall-cmd --permanent --add-source=172.16.2.0/24 --zone=internal
firewall-cmd --permanent --add-service=http --zone=internal
</pre>

If request comes from 172.16.1.0/24 or 172.16.2.0/24 then these rules apply; otherwise, the default rules apply.

## Block Access From Specific Server

<pre>
man firewalld.richlanguage
firewall-cmd --permanent --zone=internal --add-rich-rule='rule family="ipv4" source address="172.16.2.1/32" reject'
</pre>

This specifically block's the specified IP.


## Forward Port 

<pre>
man firewall-cmd
firewall-cmd --permanent --zone=internal --add-forward-port='port=8080:proto=tcp:toport=80:toaddr='
firewall-cmd --permanent --zone=internal --add-port=8080/tcp
firewall-cmd --reload
</pre>

## Allow Web Server on Port 82

<pre>
man semanage-port
yum install policycoreutils-python
semanage port -l | grep http
semanage port -a -t http_port_t -p tcp 82
</pre>

## Configure Masquerading

<pre>
firewall-cmd --query-masquerade
firewall-cmd --permanent --add-masquerade
firewall-cmd --reload
</pre>

## IP Forwarding

Add `net.ipv4.ip_forward = 1`  to `/etc/sysctl.conf`

<pre>
sysctl -p
</pre>

You can set temporarily using `echo 1 > /proc/sys/net/ipv4/ip_foward`






