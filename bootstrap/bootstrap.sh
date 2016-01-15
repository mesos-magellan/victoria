#!/bin/sh

# XXX  https://serverfault.com/questions/500764/dpkg-reconfigure-unable-to-re-open-stdin-no-file-or-directory
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install htop vim -y
