# Caching Name Server

## Install

<pre>
yum -y install unbound
</pre>

## Configure

Edit `/etc/unbound/unbound.conf`

Modify Lines:
<pre>
interfaces: 0.0.0.0
access-control: 172.16.1.0/24 allow
access-control: 172.16.2.0/24 allow
domain-insecure: "example.com"
forward-zone:
    name: "."
    forward-addr: 172.16.254.1
</pre>

## Start 

<pre>
systemctl enable unbound
systemctl start unbound
</pre>

Open Firewall

<pre>
firewall-cmd --permanent --add-service=dns
firewall-cmd --reload
</pre>


## Test

From s1
<pre>
dig @localhost www.google.com
</pre>

Should return an answer.

From c1
<pre>
dig @s1 www.google.com
dig @s1 mail.example.com
</pre>

Should return answers.

## Troubleshooting

<pre>
unbound-control dump_cache > dump.out
unbound-control load_cache < dump.out
unbound-control flush mail.example.com
</pre>

Commands
- getent hosts mail.example.com
- yum -y install syslinux
- gethostip mail.example.com 
- dig @s1 A example.com

