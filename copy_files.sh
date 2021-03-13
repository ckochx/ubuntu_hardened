#!/bin/bash
set -e

scp -i file.pem -P 2297 -v ./setup ubuntu@host:/home/ubuntu/tmp
