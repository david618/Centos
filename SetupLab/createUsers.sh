#!/bin/bash

# Create Users
useradd -u 1001 user1
useradd -u 1002 user2 
useradd -u 2001 worker1
useradd -u 2002 worker2
useradd -u 3001 manager1
useradd -u 3002 manager2

# Set Joe Passwords
echo user1:user1 | chpasswd
echo user2:user2 | chpasswd
echo worker1:worker1 | chpasswd
echo worker2:worker2 | chpasswd
echo manager1:manager1 | chpasswd
echo manager2:manager2 | chpasswd

groupadd workers -g 10001 
usermod -aG workers worker1
usermod -aG workers worker2

groupadd managers -g 10002
usermod -aG managers manager1
usermod -aG managers manager2

usermod -aG users user1
usermod -aG users user2
