#!/bin/sh

# XXX  https://serverfault.com/questions/500764/dpkg-reconfigure-unable-to-re-open-stdin-no-file-or-directory
export DEBIAN_FRONTEND=noninteractive

apt-key update
apt-get update
apt-get install sshguard grc htop vim git -y

# So that we can clone from github w/out being
#  being prompted by strict key host verification
ssh-keyscan github.com >> ~/.ssh/known_hosts

# Install python dev things
sudo apt-get install python-dev python-setuptools python-pip -y
sudo pip install virtualenv
sudo pip install whatportis
