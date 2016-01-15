#!/bin/sh

systemctl enable mesos-slave.service
systemctl start mesos-slave.service
