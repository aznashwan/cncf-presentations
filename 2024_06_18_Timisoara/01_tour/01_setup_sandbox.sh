#!/bin/bash

set -eux -o pipefail

if [ $UID -ne "0" ]; then
    echo "Must be root!"
    exit 1
fi

# Make sandbox dir and copy over notable files/directories:
SANDBOX_DIR="/sandbox"
mkdir -p "$SANDBOX_DIR"

for dir in /bin /etc /lib* /sbin /usr /var; do cp -r $dir "${SANDBOX_DIR}${dir}"; done
for dir in /boot /proc /dev /mnt /root /run /tmp; do mkdir -p "${SANDBOX_DIR}${dir}"; done

# Patch /etc/resolv.conf so we can have DNS in the 'container'
rm "$SANDBOX_DIR/etc/resolv.conf" || true
echo 'nameserver 1.1.1.1' > "$SANDBOX_DIR/etc/resolv.conf"

# Make some files to mark the real root from the fake one:
bash -c "echo 'This file is in the REAL root.' > /real-root.txt"
bash -c "echo 'This file is in the SANDBOX root.' > ${SANDBOX_DIR}/sandbox-root.txt"

# Copy over the Python Flask app we'll be containerizing:
SCRIPT_DIR=`dirname $0`
cp "${SCRIPT_DIR}/flask_app.py" "$SANDBOX_DIR/"

# Copy the bashrc and add a marker to the container's prompt:
cp /root/.bashrc "$SANDBOX_DIR/root/.bashrc"
echo 'export PS1="[C] $PS1"' > "$SANDBOX_DIR/root/.bashrc"

