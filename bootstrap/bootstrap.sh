#!/bin/sh

# XXX  https://serverfault.com/questions/500764/dpkg-reconfigure-unable-to-re-open-stdin-no-file-or-directory
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install grc htop vim -y

# Install python dev things
sudo apt-get install python-dev python-setuptools python-pip -y
sudo pip install virtualenv
sudo pip install whatportis
