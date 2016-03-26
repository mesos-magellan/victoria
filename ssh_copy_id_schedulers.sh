#!/usr/bin/env bash

HOSTS="$(echo 10.144.144.2{1..3})"

for host in $HOSTS; do
    ssh-copy-id vagrant@${host}
done
