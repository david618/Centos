# Setup Mail Server

## Postfix (SMTP)

This will be the email for example.com addresses.  For example:  `david@example.com` or `ipauser1@example.com`.

### Install

For CentOS 7; the min install already has Postfix installed.

<pre>
yum -y install postfix
systemctl enable postfix
systemctl start postfix
</pre>


### Configure

Edit /etc/postfix/main.cf

<pre>
inet_interfaces = all
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
myorigin = $mydomain
</pre>

Firewall
<pre>
firewall-cmd --permanent --add-service=smtp
firewall-cmd --reload
</pre>

Retart postfix
<pre>
systemctl restart postfix
</pre>


## Test

<pre>
yum -y install mailx
</pre>

Send an email: 
<pre>
mail -s "Some Email Subject" david
Enter the 
Body of
the Email here!
.
EOT
</pre>

Entering a period followed by return indicates termination of body and send the email.  

You can use mail command to see if it was delivered. 

Login as david
<pre>
mail
</pre>

The server should add the domain sending to `david@example.com` from 'root@example.com'. 

## Troubleshoot 

As root you can run these commands.

<pre>
List Messages in Queue: postqueue -p 
List Contents of Queue Item:  postcat -q (queue id)
Delete a Queued Item: postcat -d (queue id)
Delete all Queued Items: postcat -d ALL
Try to send messages in Queue: postqueue -f
</pre>

## Dovecot (POP3/IMAP)

To keep installation simple we'll create a simple mail POP3/IMAP server (no security).

### Install

<pre>
yum -y install dovecot
systemctl enable dovecot
systemctl start dovecot
</pre>

### Configure 

**WARNING:** This is not a secure configuration.  Only suitable for a test environment.

Edit /etc/dovecot/dovecot.conf

<pre>
Uncommend protocols line:   protocols = protocols = imap pop3 lmtp
</pre>

Edit /etc/dovecot/conf.d/10-mail.conf

<pre>
Add Line: mail_location = mbox:~/mail:INBOX=/var/spool/mail/%u
</pre>

Edit /etc/dovecot/conf.d/10-ssl.conf

<pre>
Change Line: ssl = required to ssl = yes
</pre>

Edit /etc/dovecot/conf.d/10-auth.conf

<pre>
Change Line:  disable_plaintext_auth = yes to disable_plaintext_auth = no.
</pre>

Restart Dovecot
<pre>
systemctl restart dovecot
</pre>

**Note:** Dovecot doesn't work with the default permissions on the `/var/spool/mail/%u`.  The default permissions are 660.  Workaround is to change permissions to 600 (e.g. `chmod 0600 /var/spool/mail/*`.  For real world I'd recommend using Mailbox format instead of mbox. 

<pre>
firewall-cmd --permanent --add-service=imap
firewall-cmd --permanent --add-service=pop3
firewall-cmd --reload
</pre>

### Test

Install client (e.g. mutt)

<pre>
yum -y install mutt
</pre>

Connect

<pre>
mutt -f imap://mail.example.com 
</pre>

You should be able to connect and view mail from any computer on the network. 

You'll have to enter username/password to login.







