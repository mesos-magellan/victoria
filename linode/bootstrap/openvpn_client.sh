#!/usr/bin/env bash

echo "Hello from openvpn_client.sh!"

CN_OVPN=$1

apt-get install openvpn -y
set -x
cp /vagrant/secrets/${CN_OVPN}.ovpn /etc/openvpn/${CN_OVPN}.conf
systemctl enable openvpn@${CN_OVPN}.service
systemctl start openvpn@${CN_OVPN}.service
set +x

################
# Config notes #
################
#
# 1) Create individual .ovpn profiles from server for master and scheduler00{1..3}
#    using github.com/Nyx/openvpn-install
# 2) Put those .ovpns in victoria/linode/secrets
#   2a) We take advantage of the fact that the local directory is rsync'd
#       to the server as Vagrant
# 3) Set up the server to push static IPs based on CN as follows in the
#    subsection below
# 4) When calling this script, use the same CN as $1
#    ex: ./openvpn_client.sh magellan_master

  #############################
  # Setting up openvpn server #
  #############################

  # http://michlstechblog.info/blog/openvpn-set-a-static-ip-address-for-a-client/
  #
  # ## See the following for example staticclient configs
  # root@debian:/etc/openvpn/staticclients# ls *
  # magellan_master  magellan_scheduler001	magellan_scheduler002  magellan_scheduler003
  # root@debian:/etc/openvpn/staticclients# cat *
  # ifconfig-push 10.8.0.210 255.255.255.0
  # ifconfig-push 10.8.0.221 255.255.255.0
  # ifconfig-push 10.8.0.222 255.255.255.0
  # ifconfig-push 10.8.0.223 255.255.255.0
  #
  # ## The following are important settings we must manualyl add to the
  #    server config
  # root@debian:/etc/openvpn/staticclients# cat /etc/openvpn/server.conf | tail -n 3
  # client-to-client
  # duplicate-cn
  # client-config-dir /etc/openvpn/staticclients

# 5) If all goes well, tun0 should have the IP we want and we should
#    be able to connect!
  # root@master:~# ip addr show tun0
  # 17: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 100
  #   link/none
  #   inet 10.8.0.210/24 brd 10.8.0.255 scope global tun0
  #      valid_lft forever preferred_lft forever
  #   inet6 fe80::cca:a260:e717:9659/64 scope link flags 800
  #      valid_lft forever preferred_lft forever
