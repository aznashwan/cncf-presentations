#!/bin/bash

set -eux -o pipefail

if [ $UID -ne "0" ]; then
    echo "Must be root!"
    exit 1
fi

apt-get update -y

# Install general system query utilities:
apt-get install -y tree psmisc util-linux mlocate jq

# Pre-install Python and Pip for the test flask app:
apt-get install -y python3 python3-pip

# Utilities for poking around cgroups/caps:
apt-get install -y libcap2-bin cgroup-tools

# Prereqs for touring LXC:
apt-get install -y lxc-utils lxc-templates
