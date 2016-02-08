#!/bin/sh

systemctl enable mesos-master.service
systemctl start mesos-master.service

systemctl stop mesos-slave.service
systemctl disable mesos-slave.service
