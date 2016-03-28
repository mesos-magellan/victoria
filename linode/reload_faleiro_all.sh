#!/usr/bin/env bash

HOSTS="$(echo 10.8.0.2{1..3})"

for host in $HOSTS; do
    ssh root@${host} "bash -s" < bootstrap/scheduler/scheduler_post.sh
done