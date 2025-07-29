#!/bin/bash

source loader.sh

EFIP="$(yq '.distro.partitions.efi' "$DISTRO_CONFIG" | tr -d '\"')"
ROOTP="$(yq '.distro.partitions.root' "$DISTRO_CONFIG" | tr -d '\"')"

EFIM="$(yq '.distro.mount.efi' "$DISTRO_CONFIG" | tr -d '\"')"
ROOTM="$(yq '.distro.mount.root' "$DISTRO_CONFIG" | tr -d '\"')"

run "umount -v $EFIM"
run "umount -v $ROOTM"

run "mount -v $ROOTP $ROOTM"
run "mkdir -pv $EFIM"
run "mount -v $EFIP $EFIM"
