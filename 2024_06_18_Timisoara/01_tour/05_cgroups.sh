#!/bin/bash

set -eux -o pipefail

if [ $UID -ne "0" ]; then
    echo "Must be root!"
    exit 1
fi

# Create cgroup:
cgcreate -g memory:50mbclub

# Set 50Mb RAM limit:
cgset -r memory.max=50M -r memory.swap.max=0M 50mbclub

# Execute command in cgroup using:
# cgexec -g memory:50mbclub ...
