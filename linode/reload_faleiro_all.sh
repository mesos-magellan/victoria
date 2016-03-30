#!/usr/bin/env bash

HOSTS="$(echo 10.8.0.22{1..3})"

for host in $HOSTS; do
    ssh root@${host} "cd /opt/magellan/faleiro/;
    supervisorctl -c supervisord_linode.conf shutdown;
    bash zkcli.sh delete /faleiro;
    # check zookeeper ensemble health
    for ip in 21 22 23; do echo stat | netcat 10.8.0.2${ip} 2181 | grep Mode; done"
done

for host in $HOSTS; do
    ssh root@${host} "bash -s" < bootstrap/scheduler/scheduler_post.sh
done
