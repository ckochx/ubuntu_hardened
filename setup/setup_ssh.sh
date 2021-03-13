#!/bin/bash
set -u # Fail if variable referenced does not exist
set -e # Fail fast on error

export MY_USERNAME=ck
export SSH_PORT=2297
apt-get update;
apt-get install -y openssh-server;
cp ssh_config /etc/ssh/sshd_config.d/user.conf
cp issue.net /etc/issue.net
echo "AllowUsers $MY_USERNAME ubuntu" >> /etc/ssh/sshd_config;
echo "PORT $SSH_PORT" >> /etc/ssh/sshd_config;
mkdir -p /home/"$MY_USERNAME"/.ssh;
touch /home/"$MY_USERNAME"/.ssh/authorized_keys;
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN3dOY/HhB2MONe8r1cjFFTb9Nd8scdPktl2fQTvovfv ck@Christians-MacBook-Pro.local" >> /home/"$MY_USERNAME"/.ssh/authorized_keys

service ssh start
