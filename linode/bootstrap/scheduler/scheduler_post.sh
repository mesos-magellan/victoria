#!/bin/bash

MAGELLAN_BASE_INSTALL_DIR="/opt/magellan"
FALEIRO_INSTALL_DIR="${MAGELLAN_BASE_INSTALL_DIR}/faleiro"

# Download faleiro
if [[ -d $FALEIRO_INSTALL_DIR ]]; then
    echo "faleiro is already cloned; will update."
    cd $FALEIRO_INSTALL_DIR
    git reset --hard
    git fetch
else
    echo "Cloning faleiro for the first time"
    cd $MAGELLAN_BASE_INSTALL_DIR
    git clone https://github.com/mesos-magellan/faleiro $FALEIRO_INSTALL_DIR
    cd $FALEIRO_INSTALL_DIR
fi
git checkout origin/master
# Set up and start the scheduler
./build.sh
./install.sh
./run_supervisor.sh

# frontail for log viewing
if [[ $(ps aux | grep frontail | grep -v grep) ]]; then
    echo "frontail already seems to be running. We'll kill the existing before continuing."
    sudo pkill -f frontail
fi
## Start frontail daemon to view logs on 0.0.0.0:9050
sudo frontail -p 9050 -n 500 -d --ui-highlight /var/log/faleiro/stderr.log
