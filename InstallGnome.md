# Install GNOME

Assuming you have a minimal install and you want to install GNOME.

<pre>
yum grouplist hidden | grep GNOME
yum groupinstall "GNOME Desktop"
</pre>

This installs about 1,000 packages and on my Virtual Machine pulling from a local repo took about 7 minutes.

<pre>
systemctl reboot
</pre>

After reboot in the console you'll be prompted to Accept license.  You'll need to accept before you can get to login prompt.

<pre>
systemctl list-units --type=target
</pre>

Not showing graphical.target; however, you can isolate and/or setdefault

<pre>
systemctl set-default graphical.target
systemctl isolate graphical.target
</pre>



