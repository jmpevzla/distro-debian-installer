#!/bin/bash

DISTRO_CONFIG="../distro.yaml"

LOG_FILE="../$(yq '.distro.log.file' "$DISTRO_CONFIG" | tr -d '\"')"
SHOULD_CLEAR_LOG="$(yq '.distro.log.clear_per_stage' "$DISTRO_CONFIG" | tr -d '\"')"
if [[ "$SHOULD_CLEAR_LOG" == "Yes" ]]; then
    rm -f "$LOG_FILE"
fi

ROOTM="$(yq '.distro.mount.root' "$DISTRO_CONFIG" | tr -d '\"')"

run() {
    local command="$@"
    local cmd_tee="tee -a"
    eval "$command" | $cmd_tee "$LOG_FILE"
}

info() {
    run 'echo "Distro Name: $(yq '.distro.name' "$DISTRO_CONFIG")"'
    run 'echo "Version: $(yq '.distro.number' "$DISTRO_CONFIG") - $(yq '.distro.version' "$DISTRO_CONFIG")"'
    run 'echo "Mode: $(yq '.distro.mode' "$DISTRO_CONFIG")"'
    run 'echo ""'
}

umount_part() {
    local EFIM="$(yq '.distro.mount.efi' "$DISTRO_CONFIG" | tr -d '\"')"
    run "umount -v $EFIM"
    run "umount -v $ROOTM"
}

mount_part() {
    local EFIM="$(yq '.distro.mount.efi' "$DISTRO_CONFIG" | tr -d '\"')"
    local EFIP="$(yq '.distro.partitions.efi' "$DISTRO_CONFIG" | tr -d '\"')"
    local ROOTP="$(yq '.distro.partitions.root' "$DISTRO_CONFIG" | tr -d '\"')" 
    run "mount -v $ROOTP $ROOTM"
    run "mkdir -pv $EFIM"
    run "mount -v $EFIP $EFIM"
}

umount_sys() {
    umount -v $ROOTM/sys/firmware/efi/efivars
    umount -v $ROOTM/proc
    umount -v $ROOTM/sys
    umount -v $ROOTM/dev
}

mount_sys() {
    mount -v --bind /dev $ROOTM/dev
    mount -v --bind /sys $ROOTM/sys
    mount -v --bind /proc $ROOTM/proc
    mount -v -t efivarfs none $ROOTM/sys/firmware/efi/efivars
}

stage_mount() {
    umount_sys
    umount_part
    mount_part
    mount_sys
    run 'echo ""'
}

croot() {
    run "chroot $ROOTM" "$@"
}

apt_update() {
    croot 'apt update'
}

