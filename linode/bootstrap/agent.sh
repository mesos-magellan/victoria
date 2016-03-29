#!/bin/bash

# set slave hostname for mesos to IP
echo "$(ip addr show tun0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)" | sudo tee /etc/mesos-slave/hostname

# Disable master
systemctl stop mesos-master.service
systemctl disable mesos-master.service
# Enable slave
systemctl stop mesos-slave.service
# rm -rf /tmp/mesos/meta  # XXX
systemctl enable mesos-slave.service
systemctl start mesos-slave.service

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
MAGELLAN_BASE_INSTALL_DIR="/opt/magellan"
mkdir -p $MAGELLAN_BASE_INSTALL_DIR
ENRIQUE_DIR="${MAGELLAN_BASE_INSTALL_DIR}/enrique"
### git pull
if [[ -d $ENRIQUE_DIR ]]; then
  echo "enrique is already cloned; will update."
  cd $ENRIQUE_DIR
  git reset --hard
  git fetch
else
  echo "Cloning enrique for the first time"
  cd $MAGELLAN_BASE_INSTALL_DIR
  git clone https://github.com/mesos-magellan/enrique $ENRIQUE_DIR
  cd $ENRIQUE_DIR
fi
git checkout origin/master
python setup.py develop
pip install -r requirements.txt
### Others required by enrique
sudo apt-get install git -y
