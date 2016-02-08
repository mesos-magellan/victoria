#!/bin/sh

systemctl enable mesos-slave.service
systemctl start mesos-slave.service

sudo apt-get install python-dev python-setuptools python-pip -y

## Install python mesos bindings
### XXX There's STILL no pip installable bindings so we need to download
###  and manually update the egg for now
if [ ! -f /tmp/mesos-0.27.0-py2.7-linux-x86_64.egg ]; then
    cd /tmp/
    wget http://downloads.mesosphere.io/master/debian/8/mesos-0.27.0-py2.7-linux-x86_64.egg
    easy_install mesos-0.27.0-py2.7-linux-x86_64.egg
fi

## Install enrique
cd /home/vagrant/enrique
python setup.py develop
