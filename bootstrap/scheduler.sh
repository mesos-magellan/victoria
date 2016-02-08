#!/bin/sh

# Disable all mesos services
systemctl stop mesos-master.service
systemctl disable mesos-master.service
systemctl stop mesos-slave.service
systemctl disable mesos-slave.service

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
### http://unix.stackexchange.com/a/45905/53035
sudo apt-get install -y python-software-properties debconf-utils software-properties-common
### http://www.webupd8.org/2014/03/how-to-install-oracle-java-8-in-debian.html
sudo echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
sudo echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 -y
sudo apt-get update -y
### https://askubuntu.com/questions/190582/installing-java-automatically-with-silent-option
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get install oracle-java8-installer -y

sudo apt-get install maven -y
