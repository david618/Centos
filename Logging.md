# Logging

## Log Files

|Log File          |Purpose                         |
|------------------|--------------------------------|
|/var/log/messages |Most syslog message logged here |
|/var/log/secure   |Security and auth-related msgs  |
|/var/log/maillog  |Mail logs                       |
|/var/log/boot.log |Messages related to system start|

## Service

```
systemd-journald
rsyslog
```

|Code|Priority|Severity                            |
|----|--------|------------------------------------|
|0   |emerg   |System is unstable                  |
|1   |alert   |Action must be taken immediately    |
|2   |crit    |Critical condition                  |
|3   |err     |non-critical condition              |
|4   |warning |Warning condition                   |
|5   |notice  |Normal but significant              |
|6   |info    |Information event                   |
|7   |debug   |Debug-level event                   |

## Explore Logging

```
tail -f /var/log/messages
journalctl -f
logger -p local7.notice "Hello"
journalctl -p debug -f
logger -p local7.debug "Hello"
journalctl -p debug  --since 16:00:00
journalctl --since "$(date +"%Y-%m-%d %H:%M:%S" --date="-2 hours")"
journalctl _SYSTEMD_UNIT=sshd.service
journalctl _EXE=/usr/sbin/NetworkManager
```


## List Logger

```

logger -p (tab)(tab)

auth.alert      cron.debug      ftp.err         news.alert
auth.crit       cron.emerg      ftp.error       news.crit
auth.debug      cron.err        lpr.alert       news.debug
auth.emerg      cron.error      lpr.crit        news.emerg
auth.err        daemon.alert    lpr.debug       news.err
auth.error      daemon.crit     lpr.emerg       news.error
authpriv.alert  daemon.debug    lpr.err         security.alert
authpriv.crit   daemon.emerg    lpr.error       security.crit
authpriv.debug  daemon.err      mail.alert      security.debug
authpriv.emerg  daemon.error    mail.crit       security.emerg
authpriv.err    ftp.alert       mail.debug      security.err
authpriv.error  ftp.crit        mail.emerg      security.error
cron.alert      ftp.debug       mail.err        
cron.crit       ftp.emerg       mail.error 
```



## Setup Custom Logging

Create a file: `/etc/rsyslog.d/info-messages.conf`
```
*.info /var/log/info-messages
```

Now restart and send a message

```
systemctl restart rsyslog
logger -p local7.info "Some info message"
cat /var/log/info-messages
```

## Perserving Log Journal

```
mkdir /var/log/journal
chown root:systemd-journal /var/log/journal/
chmod 2755 /var/log/journal/
yum install psmisc
killall -USR1 systemd-journald
reboot
```

After reboot

```
journalctl -b -1
```


