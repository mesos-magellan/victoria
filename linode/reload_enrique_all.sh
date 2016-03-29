#!/usr/bin/env bash


CMD="cd /opt/magellan/enrique;
git reset --hard;
git fetch;
git checkout origin/master;
python setup.py develop;
pip install -r requirements.txt"

pssh -h agents.txt -l root -p 20 -o /tmp/foo -O StrictHostKeyChecking=no ${CMD}
