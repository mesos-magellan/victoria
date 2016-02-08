#!/bin/sh

systemctl enable mesos-slave.service
systemctl start mesos-slave.service

## Install enrique
sudo apt-get install python-dev python-setuptools python-pip -y
cd /home/vagrant/enrique
python setup.py develop
