#!/bin/sh

cd /etc/mesos-slave
echo "10.144.144.10:5050" >> master
echo "/tmp/mesos-slave_work_dir" >> work_dir
echo "5041" >> port
echo "cpus(*):1; mem(*):512" >> resources
# TODO this needs to be dynamic (unless hostname is already set; check this)
# echo "agent001" >> hostname  # echo "10.144.144.11" >> hostname
