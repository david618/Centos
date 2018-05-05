# Null Client Email Server

Configure an server to use a central email server instead of local email.


## Install

```
yum -y install postfix
```

## Configure

Edit `/etc/postfix/main.cf`

Changes
```
relayhost = [mail.example.com]
myorigin = $mydomain
mynetworks = 127.0.0.0/8,[::1]/128
mydestination = 
```

Add line
```
local_transport = error:local delivery disabled
```

**Examples in help**
```
rpm -qil postfix | grep doc
cd /usr/share/doc/postfix-2.10.1
grep -rl local_transport
vi README_FILES/STANDARD_CONFIGURATION_README  << Example local_transport
grep -rl 128
vi README_FILES/IPV6_README << Example [::1]/128

```

## Start Service
```
systemctl restart postfix
systemctl enable postfix
```

## Test

```
yum -y install mailx
```

Send email (logged in as user1)
```
mail -s "test message from user1 on c1"  root
some
message
.
```

Check ipa server and sure enough root gets an email from user1.  The to and from are both @example.com.

## Troubleshooting

```
yum -y install mailx
yum -y install mutt
postqueue -p
postcat -q [queue id]
postsuper -d [queue id]
postsuper -d ALL
```
