#!/bin/bash

set -eux -o pipefail

if [ $UID -ne "0" ]; then
    echo "Must be root!"
    exit 1
fi

apt-get update -y

# Utilities for poking around:
apt-get install -y libcap2-bin
