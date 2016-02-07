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

## Install Maven and java
sudo apt-get install -y python-software-properties debconf-utils software-properties-common
sudo echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
sudo echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
sudo apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get install oracle-java8-installer

sudo apt-get install maven
