#!/bin/sh

cd /tmp
# https://github.com/outbrain/zookeepercli/releases
wget https://github.com/outbrain/zookeepercli/releases/download/v1.0.10/zookeepercli_1.0.10_amd64.deb -nv
dpkg -i zookeepercli_1.0.10_amd64.deb
rm zookeepercli_1.0.10_amd64.deb
