# System Management

## Systemd Services

Commands
- List Services: `systemctl --type=service`
- Check Enabled: `systemctl is-enabled sshd.service`
- List Enabled: `systemctl list-unit-files | grep enabled`
- Mask Service: `systemctl mask iptables`  : Prevents service from being started.
- List Maked Units: `systemctl list-unit-files --state=masked`
- List Dependencies: `systemctl list-dependencies sshd.service`
- List jobs: `systemctl list-jobs`

## Systemd Targets

Commands
- List Targets: `systemctl list-units --type=target`
- Run Target: `systemctl isolate multi-user.target`
- Get Default Target: `systemctl get-default`
- Set Default Target: `systemctl set-default multi-user.target`


## Boot Rescue or Emergency

Steps
- Press `e` during the boot (boot screen)
- Move cursor to the line starting with linux16
- Append systemd.unit=rescue.target (or emergency.target)
- Press Ctrl-x to boot

Modes
- Emergency: root file system mounted as read-only
- Rescue: root file system mounted as usual  


## Enable Persistent Logging

Steps
- `mkdir -p -m2774 /var/log/journal`
- `chown :systemd-journal /var/log/journal`
- `yum install psmisc`
- `killall -USR1 systemd-journald`
- `reboot`
- `journalctl -b-1 -p err`

Error message from last boot are shown.

## Recover Root Password

Steps
- Press e key during boot (boot loader screen)
- Move cursor to line starting with linux16
- Append rd.break
- Press Ctrl-x to boot
- `mount -oremount,rw /sysroot`
- `chroot /sysroot`
- `passwd root`
- `touch /.autorelabel`
- Exit twice (exit)

**Note:** If there are console arguments on the linux16 line remove them.

## Repairing Problem /etc/fstab

Steps
- Enter Emergency Mode (See Above)
- `mount -oremount,rw /`
- Identify and fix problems in /etc/fstab
- Exit twice (exit)
- `reboot`

## Repairing Problem with Boot Loader

Steps
- Press e key during boot (boot loader screen)
- Examine the boot loader parameters for problem and fix
- After booted
- `grub2-mkconfig`
- `grub2-mkconfig > /boot/grub2/grub.cfg`
- `systemctl reboot`

## Manage Processes

Example
```
su - worker1
```

From another shell.
```
yum -y install psmisc
pgrep -l -u worker1
pstree <PID>
pkill -SIGKILL -u worker1
```

worker1's shell is terminated.

Other commands
- System Up Time: `uptime`
- CPU Info: `cat /proc/cpuinfo`
- Processes: `top`
- Change priority of running app: `renice -n -7 <PID>`

