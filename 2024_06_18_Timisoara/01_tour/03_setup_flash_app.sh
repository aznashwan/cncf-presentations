!/bin/bash

set -eux -o pipefail

if [ $UID -ne "0" ]; then
    echo "Must be root!"
    exit 1
fi

apt-get update -y
apt-get install -y python3 python3-pip

pip3 install Flask
