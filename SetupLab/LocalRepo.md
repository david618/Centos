## Local Repo

### Install Apache Web Server

<pre>
yum -y install httpd
</pre>


### Attach iso to VM 

From Virtual Box under setting / Storage. Attache the CentOS iso image to the DVD.

### Mount the CD

From VM
<pre>
mount -t iso9660 -o ro /dev/sr0 /mnt
</pre>

### Create Folder for Repo on Web Server

<pre>
mkdir -p /var/www/html/centos/7/os/x86_64
</pre>

### Copy File

<pre>
cp -r /mnt/* /var/www/html/centos/7/os/x86_64/ 
</pre>

This will take a couple of minutes.

### Add updates

<pre>
mkdir -p /var/www/html/centos/7/updates/x86_64
</pre>

From Mirror list `https://www.centos.org/download/mirrors/` find a rsync site near you (e.g. `rsync://bay.uchicago.edu/CentOS/`)

#### Install rsync 
<pre>
yum -y install rsync
</pre>

#### Sync Packages
<pre>
rsync -rltp rsync://bay.uchicago.edu/CentOS/7/updates/x86_64/Packages /var/www/html/centos/7/updates/x86_64/
</pre>


#### Sync drpms and repodata
<pre>
rsync -rltp rsync://bay.uchicago.edu/CentOS/7/updates/x86_64/drpms /var/www/html/centos/7/updates/x86_64/
rsync -rltp rsync://bay.uchicago.edu/CentOS/7/updates/x86_64/repodata /var/www/html/centos/7/updates/x86_64/
</pre>

### Enable and Start httpd

<pre>
systemctl enable httpd
systemctl start httpd
</pre>


### Open Firewall for Http

<pre>
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
</pre>



