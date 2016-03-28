#!/usr/bin/env bash

HOSTS="$(echo 10.8.0.22{1..3})"

for host in $HOSTS; do
    ssh root@${host} "supervisorctl -c /opt/magellan/faleiro/supervisord_linode.conf shutdown"
done

for host in $HOSTS; do
    ssh root@${host} "bash -s" < bootstrap/scheduler/scheduler_post.sh
done
