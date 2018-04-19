# Manage Processes

## View Processes 

### ps 
```
ps -ef 
ps -U apache -o user,pid,cmd
ps -U apache -o user,pid,args
pstree
```

### top

The top command dynamically lists processes

### htop 

Another version of top.

## Overall System

```
uptime
cat /proc/cpuinfo
```

## Run Processes in Background

```
(while true; do echo -n "a " >> a.out; sleep 2; done) &
(while true; do echo -n "b " >> b.out; sleep 4; done) &
cat a.out
cat b.out
jobs
kill %1
```

## Killing processes

Kill using the pid found via ps or top.

```
yum -y install man-pages
man 7 signal
kill -signal PID
kill -l
killall
pkill 
```


## Terminate User 

```
w -f
pgrep -l -u worker1
pkill -SIGKILL -u worker1
```

## Being "nice"

Nice levels from -20 to +19

Priority levesl from 0 to 39

```
ps axo pid,comm,nice --sort=nice
nice -n 15 command &
renice -n 15 pid
```


Create a task using 1 cpu.

```
dd if=/dev/zero of=/dev/null &
```

You can run this several times to load multiple cpus.

```
top
renice -n 15 (pid)
top
killadd dd
```
