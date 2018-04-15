# Logging

## Log Files

|Log File          |Purpose                         |
|------------------|--------------------------------|
|/var/log/messages |Most syslog message logged here |
|/var/log/secure   |Security and auth-related msgs  |
|/var/log/maillog  |Mail logs                       |
|/var/log/boot.log |Messages related to system start|

## Service

<pre>
system-journald
rsyslog
</pre>

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

<pre>
tail -f /var/log/messages
journalctl -f
logger -p local7.notice "Hello"
journalctl -p local7.debug -f
logger -p local7.debug "Hello"
journalctl -p debug  --since 16:00:00
</pre>

## Setup Custom Logging

Create a file: `/etc/rsyslog.d/auth-errors.conf`
<pre>
authpriv.alert /var/log/auth-errors
</pre>

## Perserving Log Journal

<pre>
mkdir /var/log/journal
chown root:systemd-journal /var/log/journal/
chmod 2755 /var/log/journal/
yum install psmisc
killall -USR1 systemd-journald
reboot
</pre>

After reboot

<pre>
journalctl -b -1



