#!/bin/sh

## Install zookeepercli
cd /tmp
# https://github.com/outbrain/zookeepercli/releases
wget https://github.com/outbrain/zookeepercli/releases/download/v1.0.10/zookeepercli_1.0.10_amd64.deb -nv
dpkg -i zookeepercli_1.0.10_amd64.deb
rm zookeepercli_1.0.10_amd64.deb

## Install miguel
sudo apt-get install python-dev python-setuptools python-pip -y
sudo apt-get install libncurses5-dev libncursesw5-dev -y  # miguel requires curses
cd /home/vagrant/miguel
python setup.py develop

## Install Maven
sudo apt-get install maven
