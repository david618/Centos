# Null Client Email Server

Configure an server to use a central email server instead of local email.

## Install

<pre>
yum -y install postfix
</pre>

## Configure

Edit `/etc/postfix/main.cf`

Changes
<pre>
relayhost = [mail.example.com]
myorigin = $mydomain
mynetworks = 127.0.0.0/8,[::1]/128
mydestination = 
</pre>

Add line
<pre>
local_transport = error:local delivery disabled
</pre>


## Start Service
<pre>
systemctl restart postfix
systemctl enable postfix
</pre>

## Test

<pre>
yum -y install mailx
</pre>

Send email (logged in as user1)
<pre>
mail -s "test message from user1 on c1"  root
some
message
.
</pre>

Check ipa server and sure enough root gets an email from user1.  The to and from are both @example.com.

## Troubleshooting

<pre>
yum -y install mailx
yum -y install mutt
postqueue -p
postcat -q [queue id]
postsuper -d [queue id]
postsuper -d ALL
</pre>
