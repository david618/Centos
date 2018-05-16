# SELinux

## Help

```
yum -y install selinux-policy-devel
sepolicy manpage -a -p /usr/local/man/man8
mandb
man -k _selinux
man -k httpd_selinux
```

**Note:** For centos 7.3 created the file `touch /etc/selinux/targeted/contexts/files/file_contexts.local`

## Modes

Three Modes
- Enforcing
- Permissive
- Disabled

Set in /etc/selinux/config

**Note:** Chaning to/from Disabled requires a reboot.


Commnads
- getenforce
- setenforce

## Files/Directories

Commands
- `ls -Zd /var/www/html/`
- `ls -Z /var/www/html/index.html`

Changing
```
mkdir /sites
chcon -t httpd_sys_content_t /sites
ls -lZ /sites
restorecon -v /sites
ls -lZ /sites
```
Notice secontext changes back to default_t.

Defining default file context rules
```
yum -y install setools-console
semanage fcontext -l
restorecon -Rv /var/www/
semanage fcontext -a -t httpd_sys_content_t '/sites(/.*)?'
restorecon -RFvv /sites
```

## Booleans

```
getsebool -a
getsebool httpd_enable_homedirs
setsebool httpd_enable_homedirs on
semanage boolean -l | grep httpd_enable_homedirs
setsebool -P httpd_enable_homedirs on 
semanage boolean -l -C
```
The -P makes the change persistent.
The -l -C shows what has changed from base configuration.

## Enable Home Directories

Edit /etc/httpd/conf.d/userdir.conf.
- Comment out: UserDir disabled
- Uncomment: UserDir public_html

```
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
systemctl restart httpd
```

From a user (e.g. david)
```
cd ~
mkdir public_html
echo "david" > public_html/index.html
chmod 711 ~
```

Test
``` 
curl localhost/~david/index.html
```

## Run Service on Non Standard Port

Run Web Server on port 8888 instead of default 80.

```
semanage port -l | grep http
```

Add port 8888

```
semanage port -a -t http_port_t -p tcp 8888
```

Install and Modify Httpd to use port 8888.

```
yum -y install httpd
vi /etc/httpd/conf/httpd.conf
Modify Listen from default 80 to 888
```

Open Firewall

```
firewall-cmd --permanent --add-port=8888/tcp
firewall-cmd --reload
```




## Troubleshooting SELinux

The setroubleshootd generates log messages in /var/log/messages.
```
yum -y install setroubleshootd
systemctl reboot
```


The sealert command displays useful information about selinux errors.

```
echo "somepage" > somepage.html
mv somepage.html /var/www/html
curl localhost/somepage.html
```

You'll get a 403 Forbidden.

Look at logs
```
cat /var/log/audit/audit.log
cat /var/log/messages
sealert -l <code from messages>
```

Fix the file.

```
restorecon -Rv /var/www
curl localhost/somepage.html
```

Now it returns the content "somepage"


