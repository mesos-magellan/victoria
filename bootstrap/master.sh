#!/bin/sh

cd /etc/mesos-master
echo "10.144.144.10" >> ip
echo "/tmp/mesos-master_work_dir" >> work_dir
echo "5050" >> port
echo "master" >> hostname
