# Package Management

## yum

Commands
- `yum search 'mail'`
- `yum search all 'mail client'`
- `yum info mutt`
- `yum provides */killall`
- `yum install mutt`
- `yum update`
- `yum list kernel`
- `yum remove mutt`
- `yum group list`
- `yum group list hidden`
- `yum group info "directory client"`
- `yum group install "directory client"`
- `tail /var/log/yum.log`
- `yum history`
- `yum history undo 3`

## Repos

```
yum repolist all
```

Enable repo
```
yum-config-manager --add-repo="http://dl.fedoraproject.org/pub/epel/7/x86_64/"
```

Add entry to /etc/yum.repos.d

For example: 

```
[local-base-repo]
baseurl=http://gw.example.com/centos/7/os/x86_64
gpgcheck=0
```
