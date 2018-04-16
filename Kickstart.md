# Kickstart

## Documentation

Red Hat [help](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/chap-kickstart-installations) 

## Create Kickstart File

After installation you can find an example kickstart configuration file in root's home directory (/root) named `anaconda-ks.cfg`.

Do the first install manually then start configuring from this file.  For example `cp anaconda-ks.cfg kickst.cfg`


#### Replace CDROM with URL

Replace
<pre>
# Use CDROM installation media
cdrom
</pre>

with

<pre>
# Use URL installation media
url --url="http://172.16.254.1/centos/7/os/x86_64/"
</pre>

#### Alter clearpart 

Change --none to --all.

For example.
<pre>
# Partition clearing information
clearpart --all --initlabel
</pre>

#### Set Network Information

Set onboot to on.

<pre>
network  --bootproto=dhcp --device=ens3 --onboot=on --ipv6=auto --activate
network  --hostname=localhost.localdomain
</pre>

#### Add a reboot

Right before %package add.

<pre>
# Reboot after install
reboot
</pre>

## Check Configuration

<pre>
yum -y install pykicksstart

ksvalidate kickst.cfg
</pre>


## Place Kickstart File on Server

You can place the file on server http,ftp,nfs.

## Use the Kickstart File

### Physcial Server 

- On the Install screen hit `tab` and append to vmlinuz line (e.g. `ks=http://172.16.254.1/kickst.cfg`)

### Virtual Machine Manager 

- Do a Network Install 
- In URL Options enter Kickstart Reference (e.g. `ks=http://172.16.254.1/kickst.cfg`)
