#!/bin/bash

echo "ETH1_IP=$(ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)" > /etc/environment
