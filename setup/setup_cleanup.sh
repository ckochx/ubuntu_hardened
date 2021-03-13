#!/bin/bash
set -u # Fail if variable referenced does not exist
set -e # Fail fast on error

apt-get remove --purge xinetd nis yp-tools tftpd atftpd tftpd-hpa telnetd rsh-server rsh-redone-server
rm -rf /var/lib/apt/lists/*
