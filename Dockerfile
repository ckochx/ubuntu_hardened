FROM ubuntu:focal

#RUN dpkg-reconfigure tzdata && \
#dpkg-reconfigure locales  && \
ENV TZ=America/Chicago
RUN apt-get update  && \
apt-get upgrade -y && \
apt-get install -y git vim wget curl; \ 
apt-get remove --purge xinetd nis yp-tools tftpd atftpd tftpd-hpa telnetd rsh-server rsh-redone-server

RUN export MY_USERNAME="ck"; export MY_EMAIL="ckoch@hey.com";
RUN apt-get install -y unattended-upgrades update-notifier-common && \
dpkg-reconfigure --priority=low unattended-upgrades && \
sed -i 's#//Unattended-Upgrade::Mail "root";#Unattended-Upgrade::Mail "'$MY_EMAIL'";#' /etc/apt/apt.conf.d/50unattended-upgrades &&\
sed -i 's#//Unattended-Upgrade::MailOnlyOnError#Unattended-Upgrade::MailOnlyOnError#' /etc/apt/apt.conf.d/50unattended-upgrades &&\
sed -i 's#//Unattended-Upgrade::Automatic-Reboot "false";#Unattended-Upgrade::Automatic-Reboot "true";#' /etc/apt/apt.conf.d/50unattended-upgrades &&\
sed -i 's#//Unattended-Upgrade::Automatic-Reboot-Time "02:00";#Unattended-Upgrade::Automatic-Reboot-Time "04:00";#' /etc/apt/apt.conf.d/50unattended-upgrades

RUN ssh-keygen -A && \
adduser $MY_USERNAME && \
usermod -aG sudo $MY_USERNAME

RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN3dOY/HhB2MONe8r1cjFFTb9Nd8scdPktl2fQTvovfv ck@Christians-MacBook-Pro.local" >> ~/.ssh/authorized_keys

RUN cat ~/.ssh/config; cat ~/.ssh/authorized_keys

