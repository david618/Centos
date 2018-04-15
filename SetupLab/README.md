# Setup Lab Computers

These instructions are based on using a Physical Computer (host) running CentOS to create a set of Virtual Machine using Virtual Machine Manager.

I'm using an i7 latop with 16GB of memory and a 1TB drive. 

On the host machine I did a install "Server with GUI".

## Install Virtualization

<pre>
yum groupinstall Virtualization
</pre>

## Connect QEMU 

From Menu select File -> Connection

## Create Networks

Run Virtual Machine Manager.

From Menu select Edit -> Add Connection
- Hypervisor: QEMU/KVM
- 


Create a new Virtual Network
- Name: net17216
- Network: 172.16.0.0/16
- Enable DHCP
  - Start: 172.16.128.0
  - End: 172.16.253.255
- Ipv6
  - fd00::/64
  - DHCP
    - Start: fd00:100
    - End: fd00::1ff
- Isolated network, internal and host routing only

## Create gw VM

Options
- Local install media 
- Under Use ISO image (Browse)
- Select CentOS iso.
- Memory: 4196
- CPUs: 2
- Disk: 100G  (drive crated in /var/lib/libvirt/images; named gw.gcow2)
- Name: gw
- Check Customize configuration
- Network selection: Select the Default NAT
- Add Network: Select net17216

Do a Minimal Install

Under Device Selection select "I will configure partitioning"
- Click link to create new CentOS 7 Installation (LVM)
- Delete /home partition
- Select / partition; clear entry in "Desired Capacity"; click Update Settings
- Turn on ens3 and set hostnmae ipa.example.com  (IPA requires the hostname to be set)
- Set the Timezone

### Install Bash Completion

<pre>
yum -y install bash-completion
</pre>

Logout and log back in.

## Create c1 and s1 VM's

These can be smaller
- Memory: 1024
- CPUs: 1
- Disk: 20G
- Network Selection: net17216  (No additional network card)

Configure network for s1
<pre>
nmcli connection modify ens3 ipv4.addresses 172.16.1.1/16
nmcli connection modify ens3 ipv4.dns 172.16.254.1
nmcli connection modify ens3 ipv4.method manual
nmcli connection modify ens3 connection.autoconnect true
nmcli connection up ens3
</pre>

Configure network for c1
<pre>
nmcli connection modify ens3 ipv4.addresses 172.16.2.1/16
nmcli connection modify ens3 ipv4.dns 172.16.254.1
nmcli connection modify ens3 ipv4.method manual
nmcli connection modify ens3 connection.autoconnect true
nmcli connection up ens3
</pre>

## Create Users

Create [users](./createUsers.sh) on c1, s1, and gw.

### Setup Network

<pre>
nmcli connection modify ens4 ipv4.addresses 172.16.254.1/16
nmcli connection modify ens4 +ipv4.addresses 172.16.254.2/16
nmcli connection modify ens4 +ipv4.addresses 172.16.254.3/16
nmcli connection modify ens4 ipv4.method manual
nmcli connection modify ens4 connection.autoconnect true
nmcli connection up ens4
</pre>

The host will have DNS entries
- gw 172.16.254.1
- ipa 172.16.254.2
- mail 172.16.254.3



### Setup shell and user

<pre>
vi /etc/sudoers
</pre>

- comment out %wheel that doesn't have NOPASSWD
- uncomment the %wheel with NOPASSWD

<pre>
usermod -aG wheel david
</pre>

## Configure IP Forwarding 

Modify /etc/sysctl.conf; add line.
<pre>
net.ipv4.ip_forward = 1
</pre>

Reload sysctl
<pre>
sysctl -p
</pre>

Configure Firewall
- Internal network device: ens4  (Hostonly Network)
- External network device: ens3  (NAT Network)
<pre>
firewall-cmd --permanent --direct --add-rule ipv4 nat POSTROUTING 0 -o ens4 -j MASQUERADE
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -i ens4 -o ens3 -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -i ens3 -o ens4 -m state --state RELATED,ESTABLISHED -j ACCEPT
</pre>

To quickly 
- disable `sysctl -w net.ipv4.ip_forward=0` 
- enable `sysctl -w net.ipv4.ip_forward=1`

## Setup DNS

[Setup DNS](./DNS_Unbound.md)


## Setup LDAP / Kerberos and Yum Repo

[Setup LDAP/Kerbersos Server Using FreeIPA](./FreeIPA.md)


## Setup Mail Server

[Setup Mail Server](./MailServer.md)




