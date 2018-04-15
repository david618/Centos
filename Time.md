# Time

## Set Time

<pre>
timedatectl
timedatectl list-timezones
tzselect
timedatectl set-timezone Amercia/Chicago
timedatectl set-time 9:00:00
</pre>


## Chronyd Time Client

<pre>
yum install chrony
systemctl start chronyd
timedatectl set-ntp true
chronyc sources -v
</pre>

## Cron

Along with setting time is running tasks based on time.

### Configuration Files

<pre>
/etc/crontab
</pre>

The crontab hourly, daily, weekly are bash scripts that run periodically.


## Anacron

<pre>
/etc/anacrontab
/etc/crontab.hourly 
/etc/crontab.daily
/etc/crontab.weekly
</pre>


# Temp Files

Cron jobs cleanup Temp Files

<pre>
/etc/tmpfiles.d/*.conf
/run/tmpfiles.d/*.conf
/usr/lib/tmpfiles.d/*.conf
</pre>

Change `tmp` file deletion.

<pre>
cp /usr/lib/tmpfiles.d/tmp.conf /etc/tmpfiles.d/
vi /etc/tmpfiles.d/tmp.conf
Note: Change 10 to 1 and 30 to 3
systemd-tmpfiles --clean tmp.conf
</pre>

Manual
<pre>
man tmpfiles.d
</pre>

Create `/etc/tmpfiles.d/test.conf`
<pre>
d /test 0700 root root 30s
</pre>

Create 
<pre>
systemd-tmpfile --create test.conf
</pre>

Create some files
<pre>
mkdir /test
touch one
touch two
touch three
</pre>

Wait 30 seconds (or more).

<pre>
systemctl restart systemd-tmpfiles-clean.service
</pre>

