#!/bin/sh

systemctl enable mesos-master.service
systemctl restart mesos-master.service

systemctl stop mesos-slave.service
systemctl disable mesos-slave.service
