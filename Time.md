# Time

## Set Time

```
timedatectl
timedatectl list-timezones
tzselect
timedatectl set-timezone Amercia/Chicago
timedatectl set-time 9:00:00
```


## Chronyd Time Client

```
yum install chrony
systemctl start chronyd
timedatectl set-ntp true
chronyc sources -v
```

## Cron

Along with setting time is running tasks based on time.

### Configuration Files

```
/etc/crontab
```

The crontab hourly, daily, weekly are bash scripts that run periodically.


## Anacron

```
/etc/anacrontab
/etc/crontab.hourly 
/etc/crontab.daily
/etc/crontab.weekly
```


# Temp Files

Cron jobs cleanup Temp Files


```
/etc/tmpfiles.d/*.conf
/run/tmpfiles.d/*.conf
/usr/lib/tmpfiles.d/*.conf
```

Man pages
```
man tmpfiles.d
man systemd-tmpfiles
```

Change `tmp` file deletion.

```
cp /usr/lib/tmpfiles.d/tmp.conf /etc/tmpfiles.d/
vi /etc/tmpfiles.d/tmp.conf
Note: Change 10 to 1 and 30 to 3
systemd-tmpfiles --clean tmp.conf
```

Manual
```
man tmpfiles.d
```

Create `/etc/tmpfiles.d/test.conf`
```
d /test 0700 root root 30s
```

Create 
```
systemd-tmpfile --create test.conf
```

Create some files
```
mkdir /test
touch one
touch two
touch three
```

Wait 30 seconds (or more).

```
systemctl restart systemd-tmpfiles-clean.service
```

