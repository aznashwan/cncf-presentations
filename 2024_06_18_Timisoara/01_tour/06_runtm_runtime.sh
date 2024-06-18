#!/bin/bash

set -eux

ROOT="${ROOT:-/sandbox}"
CGROUP="${CGROUP:-}"
NETNS="${NETNS:-}"

if [ ! "$CGROUP" ]; then
    CGROUP="memory:runtm"
    cgcreate -g "$CGROUP"
fi

if [ ! "$NETNS" ]; then
    NETNS="runtm"
    ip netns create "$NETNS"
fi

cgexec -g "$CGROUP" \
    ip netns exec "$NETNS" \
    unshare \
        --mount --mount-proc --cgroup \
        --pid --fork --ipc --uts --time \
        --user --map-root-user --keep-caps \
        chroot "$ROOT" $@
