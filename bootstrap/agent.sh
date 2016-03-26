#!/bin/sh

# set slave hostname for mesos to IP
echo "$(ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)" | sudo tee /etc/mesos-slave/hostname

# Enable slave
systemctl enable mesos-slave.service
systemctl start mesos-slave.service
# Disable master
systemctl stop mesos-master.service
systemctl disable mesos-master.service

sudo apt-get install python-dev python-setuptools python-pip -y

## Install python mesos bindings
### XXX There's STILL no pip installable bindings so we need to download
###  and manually update the egg for now
if [ ! -f /tmp/mesos-0.27.0-py2.7-linux-x86_64.egg ]; then
    cd /tmp/
    wget http://downloads.mesosphere.io/master/debian/8/mesos-0.27.0-py2.7-linux-x86_64.egg -nv
    easy_install mesos-0.27.0-py2.7-linux-x86_64.egg
fi
sudo pip install mesos.interface

## Install enrique
cd /home/vagrant/enrique
sudo python setup.py develop
### Others required by enrique
sudo apt-get install git -y
