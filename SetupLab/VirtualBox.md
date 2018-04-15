## Setup Virtual Box

### Download and Install Virtual Box

Download [Oracle Virtual Box](https://www.virtualbox.org/).  There are installers for Windows, MacOX, or Linux.

### Create Extra Host-only Networks

Form VirtualBox Manager Menu Select **File -) Host Network Manager**.

You may see a default vboxnet0 192.168.56.1/24 network.

Create vboxnet1
- Configure Adatper Manually
  - IPv4 Address: 172.16.254.254
  - IPv4 Network Mask: 255.255.0.0
- DHCP Server
  - Server Address: 172.16.254.254
  - Server Mask: 255.255.0.0
  - Lower Address Bound: 172.16.10.1
  - Upper Address Bound: 172.16.10.254


Private networks
- 192.168.0.0 to 192.168.255.0: 256 class C 
- 172.16.0.0 to 172.31.0.0: 16 Class B 
- 10.0.0.0: 1 Class A Network 
  
## Create GW Servers

This server will act as gateway (route to Internate) for other test Virtual Boxes and will host some services (dns, smb, nfs, etc).

- Host IP: 172.16.254.254
- Gateway: 172.16.254.1
- Internal Servers: 172.16.1.1 to 172.16.1.254
- Internal Static IP Clients: 172.16.2.1 to 172.16.2.254
- Internal DHCP Clients: 172.16.10.1 to 172.16.10.254 

Download the DVD iso for [CentOS](https://www.centos.org/).  CentOS is a clone of RHEL.  The version `1708` is CentOS 7.4.

Create new VM
- Networks: hostonly (vboxnet1) and NAT 
- Storage: Connect Virtual DVD to CentOS iso image 
- Start the VM and install CentOS 
  - Created 80GB Virtual Drive (Manually partitioned to not have /home partition and put everything in root partition)
  - Hostname: ipa.example.com
  - Minimal Install 
  
After install of OS
- Installed bash_complettion (This provide autocomplete using tab key for bash windows; very useful)
- Configure the ip 
<pre>
nmcli connection modify enp0s8 ipv4.addresses 172.16.254.1/16
nmcli connection modify enp0s8 +ipv4.addresses 172.16.254.2/16
nmcli connection modify enp0s8 +ipv4.addresses 172.16.254.3/16
nmcli connection modify enp0s8 ipv4.method manual
nmcli connection modify enp0s8 connection.autoconnect true
nmcli connection up enp0s8
</pre>

The host will have dns entries for 
- gw : 172.16.254.1
- ipa : 172.16.254.2
- mail : 172.16.254.3 



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
- Internal network device: enp0s8  (Virtual box hostonly network)
- External network device: enp0s3  (Virtual box NAT)
<pre>
firewall-cmd --permanent --direct --add-rule ipv4 nat POSTROUTING 0 -o enp0s3 -j MASQUERADE
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -i enp0s8 -o enp0s3 -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -i enp0s3 -o enp0s8 -m state --state RELATED,ESTABLISHED -j ACCEPT
</pre>

To quickly 
- disable `sysctl -w net.ipv4.ip_forward=0` 
- enable `sysctl -w net.ipv4.ip_forward=1`

## Setup DNS

[Setup DNS](./DNS_Unbound.md)


## Setup LDAP / Kerberos

[Setup LDAP/Kerbersos Server Using FreeIPA](./FreeIPA.md)


## Seup Local Yum Repo

[Setup Local Yum Repo](./LocalRepo.md)


## Setup Mail Server

[Setup Mail Server](./MailServer.md)


