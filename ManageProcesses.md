# Manage Processes

## View Processes 

### ps 
<pre>
ps -ef 
ps -U apache -o user,pid,cmd
ps -U apache -o user,pid,args
pstree
</pre>

### top

The top command dynamically lists processes

### htop 

Another version of top.

## Overall System

<pre>
uptime
cat /proc/cpuinfo
</pre>

## Run Processes in Background

<pre>
(while true; do echo -n "a " >> a.out; sleep 2; done) &
(while true; do echo -n "b " >> b.out; sleep 4; done) &
cat a.out
cat b.out
jobs
kill %1
</pre>

## Killing processes

Kill using the pid found via ps or top.

<pre>
man 7 signal
kill -signal PID
kill -l
killall
pkill 
</pre>


## Terminate User 

<pre>
w -f
pgrep -l -u worker1
pkill -SIGKILL -u worker1
</pre>

## Being "nice"

Nice levels from -20 to +19

Priority levesl from 0 to 39

<pre>
ps axo pid,comm,nice --sort=nice
nice -n 15 command &
renice -n 15 pid
</pre>


Create a task using 1 cpu.

<pre>
dd if=/dev/zero of=/dev/null &
</pre>

You can run this several times to load multiple cpus.

<pre>
top
renice -n 15 (pid)
top
killadd dd
</pre>








