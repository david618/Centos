# Apache Web Server

## Setup Base Web Server

### Install 

```
yum -y install httpd
```

### Firewall 

```
firewall-cmd --add-service=http
firewall-cmd --add-service=https
```

### Start  
```
systemctl enable httpd.service
systemctl start httpd.service
systemctl status httpd.service
```

### Add Basic Index Page

```
echo "server1" > /var/www/html/index.html
```


### Test 

From c1 or host OS.

```
curl s1
curl -k https://s1
```


Both should return `server1`

## Setup Virtual Host 

### Create Document Folders

```
mkdir -p /srv/{default,test}/www
echo "default" > /srv/default/www/index.html
echo "test" > /srv/test/www/index.html
ls -ZR /srv
restorecon -Rv /srv
ls -ZR /srv
```

### Configure

Finding Examples
```
rpm -qil httpd | grep doc
view /usr/share/doc/httpd-2.4.6/httpd-vhosts.conf
```


```
vi /etc/httpd/conf.d/default-vhost.conf

<VirtualHost _default_:80>
    DocumentRoot "/srv/default/www"
    ServerName www.example.com
    ErrorLog "/var/log/httpd/default-error"
    CustomLog "/var/log/httpd/default-access" common
</VirtualHost>

<Directory /srv/default/www>
    Require all granted
</Directory>
```

For test
<pre>
vi /etc/httpd/conf.d/test-vhost.conf

&lt;VirtualHost *:80&gt;
    DocumentRoot "/srv/test/www"
    ServerName test.example.com
    ErrorLog "/var/log/httpd/test-error"
    CustomLog "/var/log/httpd/test" common
&lt;/VirtualHost&gt;

&lt;Directory /srv/test/www&gt;
    Require all granted
&lt;/Directory&gt;
</pre>


Check Configuration
<pre>
apachectl configtest
</pre>

Apply Configuration
<pre>
systemctl reload httpd
</pre>

### Test

You'll need to have a DNS entry for test and www or an /etc/hosts entry.

<pre>
curl www.example.com
default
curl test.example.com
test
</pre>


## Setup Python Web App

### Docs

<pre>
rpm -qil mod_wsgi
view /usr/share/doc/mod_wsgi-3.4/README
</pre>

### Install
<pre>
yum -y install mod_wsgi
</pre>

### Configure

<pre>
mkdir -p /srv/wsgiapp/www
cd /srv/wsgiapp/www
curl -O gw/helloWorld.wsgi
</pre>

The curl assumes app is available from gw server.  If not you can create it manually.

<pre>
def application(environ, start_response):
    status = '200 OK'
    output = b'Hello World! Python is so easy!\n'

    response_headers = [('Content-type', 'text/plain'),
                        ('Content-Length', str(len(output)))]
    start_response(status, response_headers)

    return [output]
</pre>

Restore tags for SeLinux.

<pre>
restorecon -rv /srv/wsgiapp/
</pre>

### Create Virtual Host

<pre>
vi /etc/httpd/conf.d/wsgiapp-vhost.conf

&lt;VirtualHost *:80&gt;
    DocumentRoot "/srv/wsgiapp/www"
    ServerName wsgiapp.example.com
    ErrorLog "/var/log/httpd/wsgiapp-error"
    CustomLog "/var/log/httpd/wsgiapp" common
    WSGIScriptAlias / /srv/wsgiapp/www/helloWorld.wsgi
&lt;/VirtualHost&gt;

&lt;Directory /srv/wsgiapp/www&gt;
    Require all granted
&lt;/Directory&gt;
</pre>

### Test

<pre>
curl wsgiapp.example.com
Hello World! Python is so easy!
</pre>

## Configure PHP Web Application

### Install Module

<pre>
yum -y install mod_php
</pre>

### Configure

<pre>
mkdir -p /srv/phpapp/www
cd /srv/phpapp/www
curl -o index.php gw/helloWorld.php
</pre>

Assumes app is available from gw server.  If not you can create it manually.

<pre>
&lt;?php
  echo "Hello World! \n";
  echo "PHP is so easy! \n";
?&gt;
</pre>

Restore tags for SeLinux.

<pre>
restorecon -rv /srv/phpapp/
</pre>

### Create Virtual Host

<pre>
vi /etc/httpd/conf.d/phpapp-vhost.conf

&lt;VirtualHost *:80&gt;
    DocumentRoot "/srv/phpapp/www"
    ServerName phpapp.example.com
    ErrorLog "/var/log/httpd/phpapp-error"
    CustomLog "/var/log/httpd/phpapp" common
    DirectoryIndex index.html index.php
&lt;/VirtualHost&gt;

&lt;Directory /srv/phpapp/www&gt;
    Require all granted
&lt;/Directory&gt;
</pre>

### Test

<pre>
curl phpapp.example.com/helloWorld.php
Hello World! 
PHP is so easy!
</pre>


## Secure Site

The mod_ssl is part of the secure configuration. 

### Configure

#### Create index page
<pre>
mkdir -p /srv/secure/www
echo 'Secure Page!' > /srv/secure/www/index.html
restorecon -rv /srv/secure/
</pre>

#### Create Server Cert

<pre>
man req

openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout server.key -out server.crt

Country Name: US
State: IL
Locality Name: Freeburg
Organization: Example
Unit: IT
hostname: secure.example.com
email: root@example.com

</pre>

Output is the server certificate (server.crt) and server key ((server.key).

Position the cert and key.

<pre>
cp server.crt /etc/pki/tls/certs/
chmod 600 /etc/pki/tls/certs/server.crt

cp server.key /etc/pki/tls/private/
chmod 400 /etc/pki/tls/private/server.key
</pre>

**Note:** If you move the files (mv) instead of copy (cp); then you'll need to run restorecon `restorecon -Rv /etc/pki/tls`


#### Create Virtual Host 

Start with similar base as other Virtual machines.  Then use `conf.d/ssl.conf` as example of extra parameters for ssl.

<pre>
&lt;VirtualHost *:443&gt;
    DocumentRoot "/srv/secure/www"
    ServerName secure.example.com
    ErrorLog "/var/log/httpd/secure-error"
    CustomLog "/var/log/httpd/secure" common
    SSLEngine on
    SSLProtocol all -SSLv2
    SSLCipherSuite HIGH:MEDIUM:!aNULL:!MD5:!SEED:!IDEA
    SSLCertificateFile /etc/pki/tls/certs/server.crt
    SSLCertificateKeyFile /etc/pki/tls/private/server.key
&lt;/VirtualHost&gt;

&lt;Directory /srv/secure/www&gt;
    Require all granted
&lt;/Directory&gt;
</pre>

### Reload and Test

<pre>
systemctl reload httpd
</pre>

From another computer.

<pre>
curl -k https://secure.example.com
Secure Page!
</pre>


**Note:** Adding `ServerAlias *` to ssl.conf sent any request other than `https://secure.example.com` to default. 








