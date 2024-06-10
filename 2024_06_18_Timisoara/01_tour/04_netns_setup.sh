#!/bin/bash

set -eux -o pipefail

if [ $UID -ne "0" ]; then
    echo "Must be root!"
    exit 1
fi

# Create namespace:
ip netns add ns1

# Create veth pair:
ip link add veth0 type veth peer name veth1

# Move one of the veths into the namespace:
ip link set veth1 netns ns1

# Set IP and UP on the host's veth:
ip addr add 192.168.200.1/24 dev veth0
ip link set dev veth0 up

# Set IP and UP on the veth from within the network namespace:
ip netns exec ns1 ip addr add 192.168.200.2/24 dev veth1
ip netns exec ns1 ip link set dev veth1 up

# Exec commands in namespace using:
ip netns exec ns1 ping -c 3 192.168.200.1
