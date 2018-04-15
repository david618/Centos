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
<pre>
yum grouplist hidden | grep Directory
yum groupinstall "Directory Client"
</pre>

### Copy CA.crt

<pre>
cd /etc/openldap/cacerts
curl -O ipa.example.com/ca.crt
cat ca.crt
</pre>

You should see the CA certificate.

### Run Installer 

<pre>
authconfig-tui 
</pre>

- User Information: Check Use LDAP
- Authentication: Check Use LDAP AUthentication (Leave others)
- Next
- Check Use TLS
- Server: ipa.example.com
- Base DN: dc=example,dc=com
</pre>get

Check to see if it's working

<pre>
su - ipauser1
</pre>

If configured you'll now be ipauser1.  You will see an error about home directory. 

<pre>
getent passwd ipauser1
getent passwd ipauser2
</pre>

### Enable Make Home Directory

<pre>
authconfig --enablemkhomedir --updateall
</pre>

### Authenticate to Kerberos

<pre>
yum -y install pam_krb5
</pre>

**Note:** Without pam_krb5 autenticate-tui will give some errors.

<pre>
authenticate-tui
</pre>

- LDAP Configuration same as above
- Kerberos
  - Realm: EXAMPLE.COM
  - KDS: ipa.example.com
  - Admin Server: ipa.example.com
  - DNS: Leave both unchecked

Test
<pre>
ssh ipauser2@localhost
whoami
pwd
exit
</pre>

## Configure Using GTK

First install X-Windows

Takes about 7 minutes to install X-Windows on min install.

<pre>
yum -y groupinstall "X Windows System"
systemctl isolate graphical.target
yum -y install authconfig-gtk
</pre>

The GUI is pretty much the same as TUI; with the execption you have an option to "Create home directories on first login"

## Install IPA Client

<pre>
yum -y install ipa-client
ipa-client-install --domain=ipa.example.com --no-ntp --mkhomedir
</pre>





