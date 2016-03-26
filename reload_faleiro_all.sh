#!/usr/bin/env bash

HOSTS="$(echo 10.144.144.2{1..3})"

source ssh_copy_id_schedulers.sh

for host in $HOSTS; do
    ssh vagrant@${host} "bash -s" < bootstrap/scheduler/scheduler_post.sh
done
