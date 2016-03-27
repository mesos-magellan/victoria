#!/bin/bash

echo "TUN0_IP=$(ip addr show tun0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)" > /etc/environment
