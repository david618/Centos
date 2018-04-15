# Key Based Authentication

## Create Key

<pre>
ssh-keygen 
</pre>

Defaults create key id_rsa key and public key (id_rsa.pub) in the .ssh folder.   

For password-less entry leave password's blank.



## Copy Key to Server

To ssh to another server. 

<pre>
ssh-copy-id s1
</pre>

## Manually 

Add the public key to ~/.ssh/authorized_keys of the server you want to log into.  


