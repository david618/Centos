# Networking 

## Documentation

Network Scripts are in: `/etc/sysconfig/network-scripts`

Man Pages
- Configuration Parameters:  `man -K PEERDNS` or `man nm-settings-ifcfg-rh`


## Commands

hostnamectl
- Set Hostname: `hostnamectl set-hostname c1.example.com`
- See hostname: `cat /etc/hostname`

nmcli
- Device Show: `nmcli dev show`
- Device Status: `nmcli dev status`
- Show Connections: `nmncli connection sho`
- Show ipv4 for eth1: `nmcli connection show eth1 | grep ipv4`
- Show Devices: `nmcli device show | grep DEVICE`

ip
- Show addresses: `ip addr`
- Show one line ipv4 addresses: `ip -4 -o addr`
- Show route: `ip route`

## Change DHCP to Manual IP

Change eth0 from dhcp to manual ip

```
nmcli connection down eth0
nmcli connection modify eth0 ipv4.addresses 172.16.2.11/16
nmcli connection modify eth0 ipv4.method manual
nmcli connection modify eth0 connection.autoconnect true
nmcli connection up eth0
```


## Manually Disable Auto DNS

Modified the ifcfg script in /etc/sysconfig/network-scripts.

Add or modifiy: `PEERDNS=no`

## Disable Auto DNS using nmcli

```
nmcli connection mod eth0 ipv4.ignore-auto-dns yes
```


## Bind Multiple IP's to Same Network Card

Add ip addresses
```
nmcli connection modify eth0 +ipv4.addresses 172.16.2.12/16
nmcli connection modify eth0 +ipv4.addresses 172.16.2.13/16
nmcli connection up eth0
ip -4 -o addr 
3: eth0    inet 172.16.2.11/16 brd 172.16.255.255 scope global eth0\       valid_lft forever preferred_lft forever
3: eth0    inet 172.16.2.12/16 brd 172.16.255.255 scope global secondary eth0\       valid_lft forever preferred_lft forever
3: eth0    inet 172.16.2.13/16 brd 172.16.255.255 scope global secondary eth0\       valid_lft forever preferred_lft forever
```

Use Miinus sign to remove.

<pre>
nmcli connection modify eth0 -ipv4.addresses 172.16.2.12/16
nmcli connection modify eth0 -ipv4.addresses 172.16.2.13/16
nmcli connection up eth0
</pre>


## Routes

Create Static Route
<pre>
ip route add 172.16.0.0/16 via 172.16.2.11 dev eth0
</pre>

Delete a Route
<pre>
ip route del 172.16.0.0/16 dev bond0
</pre>


## IPV6

128-bit (Network Defined in first 64 bits: First 48 bits location last 16 bits subnets)

Multicast: ff00://8   (Equivalent of 224.0.0.0/4 in IPV4)

### Concise Writing

Full number: `2001:0db8:0000:0001:0000:0000:0000:0001`
Concise:  `2001:db8:0:1::1`

- Leading zeros dropped in each group
- One set of repeating zero groups can be replaced with ::

### Create Link Local Address based on Ehternet Card 

Procedure
- Given MAC Address (00:11:22:aa:bb:cc)
- Toggle the 7th bit in of first number: `00000000` changes to `00000010`
- The Link Local address starts with fe80::
- Add the first 3 digraphs from MAC with toggle: 0211:22 
- Add ff:ee
- Add last 3 digraphs from MAC: aa:bbcc
- Final IPV6: fe80::0211:22ff:eeaa:bbcc/64

Another example
- Given MAC Address (52:54:00:53:61:38)
- Change 52 (01010010) to 50 (01010000)
- Final IPV6: fe80::5054:00ff:ee53:6138/64

## Bonding

Bonding is older way to configure multiple network cards to act as one.

```
modprobe bonding
modinfo bonding
nmcli connection add type bond con-name bond0 ifname bond0 mode balance-rr
nmcli connection modify bond0 ipv4.addresses 172.16.2.21/16
nmcli connection modify bond0 ipv4.method manual
nmcli connection modify bond0 ipv6.addresses fd00:aaaa:bbbb:1::1/64
nmcli connection modify bond0 ipv6.method manual
nmcli connection add type bond-slave con-name bond0-p1 ifname eth0 master bond0
nmcli connection add type bond-slave con-name bond0-p2 ifname eth1 master bond0
nmcli connection up bond0
ping -I bond0 172.16.254.1
```

From another window
```
nmcli device disconnect eth0
nmcli device disconnect eth1
```

As long as one of the two (eth0 or eth1) then bond0 works.

Taking down connection.

```
nmcli connection down bond0
nmcli connection delete bond0-p1
nmcli connection delete bond0-p2
nmcli connection delete bond0
nmcli connection stop eth0
nmcli connection stop eth1
```

## Teaming

```
nmcli connection add type team con-name team0 ifname team0 config '{"runner":{"name":"activebackup"}}'
nmcli connection modify team0 ipv4.addresses 172.16.2.21/16
nmcli connection modify team0 ipv4.method manual
nmcli connection modify team0 connection.autoconnect true
nmcli connection add type team-slave con-name team0-p1 ifname eth0 master team0
nmcli connection add type team-slave con-name team0-p2 ifname eth1 master team0
nmcli connection up team0
teamdctl team0 state
```

You should see the to ports and there status.

Some help:  `man teamd.conf`

Commands
- List ports: `teamnl team0 ports`
- Show Active port: `teamnl team0 getoption activeport`

Testing

```
ping -I team0 172.16.254.1
```

From another window
```
nmcli device disconnect eth0
Pings continue

teamdctl team0 state 
You can see the active port as changed to eth1

nmcli device disconnect eth1
Pings stop

nmcli device connect eth0
Pings start again
```

Taking down connection.

```
nmcli connection down team0
nmcli connection delete team0-p1
nmcli connection delete team0-p2
nmcli connection delete team0
nmcli connection stop eth0
nmcli connection stop eth1
```

### Watching 

Install tcpdump

In a roundrobin config open two windows.

In one: `tcpdump -i ens4 icmp and dst host 172.16.0.1`
In the other: `tcpdump -i ens5 icmp and dst host 172.16.0.1`

Now from host start ping.  `ping s2`

You should see messages alternating between the two hosts.


## Software Bridge

### Create Bridge

```
nmcli connection add type bridge con-name br0 ifname br0
nmcli connection modify br0 ipv4.addresses 172.16.2.11/16
nmcli connection modify br0 ipv4.method manual
nmcli connection add type bridge-slave con-name br0-pt1 ifname eth0 master br0
nmcli connection add type bridge-slave con-name br0-pt2 ifname eth1 master br0
nmcli connection up br0
```

Install utils
```
yum -y install bridge-utils
brctl show
```


### Create Bridge from Team 

```
nmcli connection add type team con-name team0 ifname  team0 config '{"runner":{"name":"roundrobin"}}'
nmcli connection add type team-slave con-name team0-pt1 ifname eth0 master team0
nmcli connection add type team-slave con-name team0-pt2 ifname eth1 master team0
teamdctl team0 state
```

Team networks don't work with bridge.
- Create a Team (team and team-slave)
- Created a Bridge (Set ip)

```
systemctl -y install bridge-utils
systemctl device disconnect team0
systemctl stop NetworkManager
systemctl disable NetworkManager
```

Edit /etc/sysconfig/network-script/ifcfg-team0.

```
Delete BOOTPROTO
Add Line
BRIDGE=br0
```

Remove IP configurations from team0 configurations; if they exist.













