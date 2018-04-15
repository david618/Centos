# Setup FreeIPA on CentOS 7

## Open Firewall 

<pre>
firewall-cmd --permanent --add-port={80/tcp,443/tcp,389/tcp,636/tcp,88/tcp,464/tcp,53/tcp,88/udp,464/udp,53/udp,123/udp}
firewall-cmd --reload
</pre>

## Check DNS entries

<pre>
yum install bind-utils
dig +short ipa.example.com A
</pre>

## Install Random Number Generator

<pre>
yum install rng-tools
systemctl start rngd
systemctl enable rngd
</pre>

At 7.4 there is a problem with rngd.  

<pre>
systemctl list-units
</pre>

Scrolling down you'll see rngd.service is "failed"

<pre>
systemctl status rngd
</pre>

The fix was found at [this site](https://www.theurbanpenguin.com/centos-7-rngd-will-not-start/).

Change ExecStart in `/usr/lib/systemd/system/rngd.service`
<pre>
ExecStart=/sbin/rngd -f -r /dev/urandom
</pre>

Restart Service
<pre>
systemctl daemon-reload
systemctl restart rngd
systemctl status rngd
</pre>


## Install ipa-server

<pre>
yum -y install ipa-server
</pre>

## Modify Hosts File

Add entry to /etc/hosts
<pre>
172.16.254.2  ipa.example.com
</pre>

## Run IPA Installation Script

<pre>
ipa-server-install

Do you want to configure integrated DNS (BIND)? [no]: no

Server host name [ipa.example.com]: 
Please confirm the domain name [example.com]: 
Please provide a realm name [EXAMPLE.COM]: 


</pre>

## Verify FreeIPA

<pre>
kinit admin
ipa user-find admin
</pre>

## Web UI

<pre>
https://ipa.example.com
</pre>

Added /etc/hosts entry in Virutal Box host.  

Added users ipauser1 and ipauser2 set password to `password`

Logged into web ui as ipauser1 and changed password on first login to `ipauser1`
Logged into web ui as ipauser2 and changed password on first login to `ipauser2`

From Groups added both ipauser1 and ipauser2 to the editors group.

## Setup Yum Repo

You'll need to setup the repo in order to download and install ipa client on s1 and c1.

### Attach iso to VM 

From Virtual Box under setting / Storage. Attach the CentOS iso image to the DVD.

### Mount the CD

From VM
<pre>
mount -t iso9660 -o ro /dev/sr0 /mnt
</pre>

### Create Folder for Repo on Web Server

<pre>
mkdir -p /var/www/html/centos/7/os/x86_64
</pre>

### Copy File

<pre>
cp -r /mnt/* /var/www/html/centos/7/os/x86_64/ 
</pre>

This will take a couple of minutes.

<pre>
umount /mnt
</pre>


### Configure ipa,s1,and c1 to use Local Repo

On s1 and c1 setup dns.

<pre>
nmcli con mod ens3 ipv4.dns 172.16.254.1
nmcli con up ens3
</pre>



Remove CentOS*.repo from /etc/yum.repo.d/.

Create /etc/yum.repo.d/local.repo.\
<pre>
[local-base-repo]
name=Local Base Repo
baseurl=http://gw.example.com/centos/7/os/x86_64
gpgcheck=0
</pre>

## Add c1 and s1 as IPA Clients

Run ipa-client-install

<pre>
yum -y install ipa-client
ipa-client-install
</pre>

Answers
<pre>
Domain: example.com
IPA Server: ipa.example.com
</pre>

## Configure IPA Services

Using IPA WebUI.

Add nfs service for c1.example.com, s1.example.com, and ipa.example.com.

## Generate the keytab file

From ipa server

<pre>
ipa-getkeytab -s ipa.example.com -p nfs/ipa.example.com -k /etc/krb5.keytab
ipa-getkeytab -s ipa.example.com -p host/c1.example.com -k /etc/krb5.keytab
ipa-getkeytab -s ipa.example.com -p nfs/c1.example.com -k /etc/krb5.keytab
ipa-getkeytab -s ipa.example.com -p host/s1.example.com -k /etc/krb5.keytab
ipa-getkeytab -s ipa.example.com -p nfs/s1.example.com -k /etc/krb5.keytab
</pre>



## Put Cert and Keytab files in Web Folder

<pre>
cp /etc/ipa/ca.crt /var/www/html
cp /etc/krb5.keytab /var/www/html
chmod 644 /var/www/html/krb5.keytab
</pre>




