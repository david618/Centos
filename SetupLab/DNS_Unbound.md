## Setup Domain Name Service (DNS)

Reasons to install DNS
- Names are much easier to remember than IP addresses 
- Many network services require DNS

Unbound can be used as DNS for CentOS/RHEL.

### Install Unbound

<pre>
yum -y install unbound
systemctl enable unbound
systemctl start unbound
</pre>

### Configure Unbound
Edit /etc/unbound/unbound.conf

Change these lines
<pre>
interface: 0.0.0.0
interface-automatic: yes
access-control: 172.16.0.0/16 allow
domain-insecure: "example.com"
  forward-zone:
        name: "."
        forward-addr: 8.8.8.8
</pre>

Modify /etc/unbound/local.d/block-example.com.conf.  Update as [block-example.com.conf](./block-example.com.conf)

### Retart and Verify 

<pre>
unbound-checkconf
</pre>

Should return no errors.

<pre>
systemctl restart unbound
</pre>

Now try dig.  `yum -y install bind-utils`

<pre>
dig @172.16.254.1 c1.example.com
dig @172.16.254.1 +noall +answer c1.example.com
</pre>

You should see an answer that shows 172.16.2.1.

### Configure Lookup

<pre>
cat /etc/resolv.conf
# Generated by NetworkManager
search jennings.home example.com
nameserver 10.0.2.3
</pre>

This output show the NAT address 10.0.2.3 is used as the default nameserver.  We need to disable this auto entry.

You can disable by editing network scripts or using nmcli

#### Editing Scripts

Edit the network-script for ens3.

vi /etc/sysconfig/network-scripts/ifcfg-ens3

Changed PEERDNS=yes to PEERDNS=no

#### Using nmcli

<pre>
nmcli con mod ens3 ipv4.ignore-auto-dns yes
</pre>

#### Configure DNS

Now add gw as DNS server.  `nmcli connection modify ens4 ipv4.dns 172.16.254.1`

After reboot; look at /etc/resolv.conf

<pre>
# Generated by NetworkManager
search example.com
nameserver 172.16.254.1
</pre>

Now dig should work for both internal and external names.

<pre>
dig +noall +answer c1.example.com
dig +noall +answer www.google.com
</pre>

### Update Firewall

<pre>
firewall-cmd --permanent --add-service=dns
firewall-cmd --reload
</pre>





