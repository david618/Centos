# Setup Mail Server

## Postfix (SMTP)

This will be the email for example.com addresses.  For example:  `david@example.com` or `ipauser1@example.com`.

### Install

For CentOS 7; the min install already has Postfix installed.

```
yum -y install postfix
systemctl enable postfix
systemctl start postfix
```


### Configure

Edit /etc/postfix/main.cf

```
inet_interfaces = all
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
myorigin = $mydomain
```

Firewall
```
firewall-cmd --permanent --add-service=smtp
firewall-cmd --reload
```

Retart postfix
```
systemctl restart postfix
```


## Test

```
yum -y install mailx
```

Send an email: 
```
mail -s "Some Email Subject" david
Enter the 
Body of
the Email here!
.
EOT
```

Entering a period followed by return indicates termination of body and send the email.  

You can use mail command to see if it was delivered. 

Login as david
```
mail
```

The server should add the domain sending to `david@example.com` from 'root@example.com'. 

## Troubleshoot 

As root you can run these commands.

```
List Messages in Queue: postqueue -p 
List Contents of Queue Item:  postcat -q (queue id)
Delete a Queued Item: postsuper -d (queue id)
Delete all Queued Items: postsuper -d ALL
Try to send messages in Queue: postqueue -f
```

## Dovecot (POP3/IMAP)

To keep installation simple we'll create a simple mail POP3/IMAP server (no security).

### Install

```
yum -y install dovecot
systemctl enable dovecot
systemctl start dovecot
```

### Configure 

**WARNING:** This is not a secure configuration.  Only suitable for a test environment.

Edit /etc/dovecot/dovecot.conf

```
Uncommend protocols line:   protocols = protocols = imap pop3 lmtp
```

Edit /etc/dovecot/conf.d/10-mail.conf

```
Add Line: mail_location = mbox:~/mail:INBOX=/var/spool/mail/%u
```

Edit /etc/dovecot/conf.d/10-ssl.conf

<pre>
Change Line: ssl = required to ssl = yes
</pre>

Edit /etc/dovecot/conf.d/10-auth.conf

```
Change Line:  disable_plaintext_auth = yes to disable_plaintext_auth = no.
```

Restart Dovecot
```
systemctl restart dovecot
```

**Note:** Dovecot doesn't work with the default permissions on the `/var/spool/mail/%u`.  The default permissions are 660.  Workaround is to change permissions to 600 (e.g. `chmod 0600 /var/spool/mail/*`.  For real world I'd recommend using Mailbox format instead of mbox. 

```
firewall-cmd --permanent --add-service=imap
firewall-cmd --permanent --add-service=pop3
firewall-cmd --reload
```

### Test

Install client (e.g. mutt)

```
yum -y install mutt
```

Connect

```
mutt -f imap://mail.example.com 
```


You should be able to connect and view mail from any computer on the network. 

You'll have to enter username/password to login.







