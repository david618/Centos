# LDAP / Kerberous Authentication Client Configuration

This assumes you already have the LDAP/Kerberos server setup.

- LDAP Server: ldaps://ipa.example.com
- LDAP Base DN: dc=example,dc=com
- LDAP Certificate:  `http://ipa.example.com/ca.crt`
- Kerberos Realm: EXAMPLE.COM
- Kerberos KDC: ipa.example.com
- Kerberos Admin Server: ipa.example.com

User: ipauser1/ipauser1


## Setup LDAP Auth using authconfig-tui

You'll need the ca.crt from the IPA server.  The cert is located on FreeIPA server in /etc/ipa.  File named ca.crt.

Copy the file to the client and put it in /etc/openldap/cacerts/

From client 

### Install Software Needed
```
yum grouplist hidden | grep Directory
yum groupinstall "Directory Client"
```

### Copy CA.crt

```
cd /etc/openldap/cacerts
curl -O ipa.example.com/ca.crt
cat ca.crt
```

You should see the CA certificate.

### Run Installer 

```
authconfig-tui 
```

Following Options
- User Information: Check Use LDAP
- Authentication: Check Use LDAP AUthentication (Leave others)
- Next
- Check Use TLS
- Server: ipa.example.com
- Base DN: dc=example,dc=com


Check to see if it's working

```
su - ipauser1
```

If configured you'll now be ipauser1.  You will see an error about home directory. 

```
getent passwd ipauser1
getent passwd ipauser2
```

### Enable Make Home Directory

```
authconfig --enablemkhomedir --updateall
```

### Authenticate to Kerberos

```
yum -y install pam_krb5
```

**Note:** Without pam_krb5 autenticate-tui will give some errors.

```
authenticate-tui
```

- LDAP Configuration 
  - Uncheck: Use LDAP Authentication 
  - Check: Use Kerberos
- Kerberos
  - Realm: EXAMPLE.COM
  - KDS: ipa.example.com
  - Admin Server: ipa.example.com
  - DNS: Leave both unchecked

Test
```
ssh ipauser2@localhost
whoami
pwd
exit
```

## Configure Using GTK

First install X-Windows

Takes about 7 minutes to install X-Windows on min install.

```
yum -y groupinstall "X Windows System"
systemctl isolate graphical.target
yum -y install authconfig-gtk
```

The GUI is pretty much the same as TUI; with the execption you have an option to "Create home directories on first login"

## Install IPA Client

```
yum -y install ipa-client
ipa-client-install --domain=ipa.example.com --no-ntp --mkhomedir
```





