#!/bin/bash

dconfig() {
    DISTRO_CONFIG="$1/distro.yaml"
}

rootm() {
    ROOTM="$(yq '.distro.mount.root' "$DISTRO_CONFIG" | tr -d '\"')"
}

dlog() {
    LOG_FILE="$1/$(yq '.distro.log.file' "$DISTRO_CONFIG" | tr -d '\"')"
    SHOULD_CLEAR_LOG="$(yq '.distro.log.clear_per_stage' "$DISTRO_CONFIG" | tr -d '\"')"
    if [[ "$SHOULD_CLEAR_LOG" == "Yes" ]]; then
	rm -f "$LOG_FILE"
    fi
}

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

get_desc() {
    yq -r '.distro.stages[] | .script, .desc' "$DISTRO_CONFIG" | while IFS= read -r script && IFS= read -r desc; do
	if [[ $script == "$1"  ]]; then
	    run 'echo "$desc"'
	    run 'echo ""'
	    break
	fi
    done
}

umount_part() {
    local EFIM="$(yq '.distro.mount.efi' "$DISTRO_CONFIG" | tr -d '\"')"
    run "umount -v -R $EFIM"
    run "umount -v -R $ROOTM"
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
    run "umount -v -R $ROOTM/proc"
    run "umount -v -R $ROOTM/sys"
    run "umount -v -R $ROOTM/dev"
    run "umount -v -R $ROOTM/run"
}

mount_sys() { 
    run "mount -v --types proc /proc $ROOTM/proc"
    run "mount -v --rbind /sys $ROOTM/sys"
    run "mount -v --make-rslave $ROOTM/sys"
    run "mount -v --rbind /dev $ROOTM/dev"
    run "mount -v --make-rslave $ROOTM/dev"
    run "mount -v --rbind /run $ROOTM/run"
    run "mount -v --make-slave $ROOTM/run"
}

stage_mount() {
    umount_sys
    umount_part
    mount_part
    mount_sys
    run 'echo ""'
}

load_path() {
    dconfig ".."
    dlog ".."
    rootm
}

load_single() {
    stage_mount
    run 'echo ""'
    info   
}

croot() {
    run "chroot $ROOTM" "$@"
}

apt_update() {
    croot 'apt update'
}

