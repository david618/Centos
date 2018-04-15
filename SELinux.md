# SELinux

## Help

<pre>
yum -y install selinux-policy-dco
mandb
man -k _selinux
man -k httpd_selinux
</pre>


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
<pre>
mkdir /sites
chcon -f https_sys_content_t /sites
restorecon -v /virtual
</pre>

Defining default file context rules
<pre>
yum -y install setools-console
semanage fcontext -l
restorecon -Rv /var/www/
semanage fcontext -a -t httpd_sys_content_t '/sites(/.*)?'
restorecon -RFvv /sites
</pre>

## Booleans

<pre>
getsebool -a
getsebool httpd_enable_homedirs
setsebool httpd_enable_homedirs on
semanage boolean -l | grep httpd_enable_homedirs
setsebool -P httpd_enable_homedirs on 
semanage boolean -l -C
</pre>
The -P makes the change persistent.
The -l -C shows what has changed from base configuration.

## Enable Home Directories

Edit /etc/httpd/conf.d/userdir.conf.

Set UserDir public_html

<pre>
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
systemctl restart httpd
</pre>

From a user (e.g. david)
<pre>
cd ~
mkdir /public_html
echo "david" > /public_html/index.html
chmod 711 ~
</pre>

Test
<pre> 
curl localhost/~david/index.html
</pre>

## Troubleshooting SELinux

The setroubleshootd generates log messages in /var/log/messages.

The sealert command displays useful information about selinux errors.

<pre>
echo "somepage" > somepage.html
mv somepage.html /var/www/html
curl localhost/somepage.html
</pre>

You'll get a 403 Forbidden.

Look at logs
<pre>
cat /var/log/audit/audit.log
cat /var/log/messages
sealert -l <code from messages>
</pre>

Fix the file.

<pre>
restorecon -Rv /var/www
curl localhost/somepage.html
</pre>

Now it returns the content "somepage"


