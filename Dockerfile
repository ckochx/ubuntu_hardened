FROM ubuntu:focal
# ubuntu 20.04

ENV TZ="America/Chicago" MY_USERNAME="ck" MY_EMAIL="ckoch@hey.com"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update  && \
    apt-get upgrade -y && \
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common \
        vim \
        curl \
        fail2ban \
        openssh-client \
        sudo; \
    apt-get remove --purge xinetd nis yp-tools tftpd atftpd tftpd-hpa telnetd rsh-server rsh-redone-server

# Setup unattended upgrades
RUN apt-get install -y unattended-upgrades update-notifier-common && \
    dpkg-reconfigure --priority=low unattended-upgrades && \
    sed -i 's#//Unattended-Upgrade::Mail "root";#Unattended-Upgrade::Mail "'$MY_EMAIL'";#' /etc/apt/apt.conf.d/50unattended-upgrades &&\
    sed -i 's#//Unattended-Upgrade::MailOnlyOnError#Unattended-Upgrade::MailOnlyOnError#' /etc/apt/apt.conf.d/50unattended-upgrades &&\
    sed -i 's#//Unattended-Upgrade::Automatic-Reboot "false";#Unattended-Upgrade::Automatic-Reboot "true";#' /etc/apt/apt.conf.d/50unattended-upgrades &&\
    sed -i 's#//Unattended-Upgrade::Automatic-Reboot-Time "02:00";#Unattended-Upgrade::Automatic-Reboot-Time "04:00";#' /etc/apt/apt.conf.d/50unattended-upgrades

RUN ssh-keygen -A && \
    useradd $MY_USERNAME && useradd bitwarden && \
    groupadd docker && \
    usermod -aG docker bitwarden; \
    usermod -aG docker "$MY_USERNAME";  \
    usermod -aG sudo $MY_USERNAME; \
    usermod -aG sudo bitwarden; \
    mkdir /opt/bitwarden && chmod -R 700 /opt/bitwarden && \
    chown -R bitwarden:bitwarden /opt/bitwarden; \
    echo "$MY_USERNAME:$MY_USERNAME" | chpasswd; 

## Setup docker (for bitwarden)
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -; \
    add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"; \
    apt-get update; \
    apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io;

## SETUP SSH
#RUN apt-get install -y openssh-server; \
#rm -rf /var/lib/apt/lists/*
#COPY ssh_config /etc/ssh/sshd_config
#COPY issue.net /etc/issue.net
#RUN mkdir -p /home/"$MY_USERNAME"/.ssh; echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN3dOY/HhB2MONe8r1cjFFTb9Nd8scdPktl2fQTvovfv ck@Christians-MacBook-Pro.local" > /home/"$MY_USERNAME"/.ssh/authorized_keys
#RUN sudo service ssh start

## Install and Configure Bitwarden
USER bitwarden
RUN curl -Lso /opt/bitwarden/bitwarden.sh https://go.btwrdn.co/bw-sh \
    && chmod +x /opt/bitwarden/bitwarden.sh;

USER root
# cmd /opt/bitwarden/bitwarden.sh start

#EXPOSE 2297
#ENTRYPOINT sudo service ssh restart && bash

