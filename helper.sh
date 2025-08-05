#!/bin/bash

dconfig() {
    DISTRO_CONFIG="$1/distro.yaml"
}

rootm() {
    ROOTM="$(yq '.distro.mount.root' "$DISTRO_CONFIG" | tr -d '\"')"
}

dlog() {
    LOG_FILE="$1/$(yq '.distro.log.file' "$DISTRO_CONFIG" | tr -d '\"')"
    SHOULD_CLEAR_LOG="$(yq '.distro.log.clear_at_init' "$DISTRO_CONFIG" | tr -d '\"')"
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
    local SWAPMODE="$(yq -r '.distro.swap.mode' "$DISTRO_CONFIG")"
    if [[ $SWAPMODE == "file" ]]; then
	local SWAPFILE="$(yq -r '.distro.swap.file.name' "$DISTRO_CONFIG")"
	run "swapoff -v $ROOTM/$SWAPFILE"
    fi
    run "umount -v -R $ROOTM"
}

mount_part() {
    local MODE="$(yq -r '.distro.mode' "$DISTRO_CONFIG")"

    local EFIM="$(yq -r '.distro.mount.efi' "$DISTRO_CONFIG")"
    local EFIP="$(yq -r '.distro.partitions.efi' "$DISTRO_CONFIG")"
    local ROOTP="$(yq -r '.distro.partitions.root' "$DISTRO_CONFIG")"

    local BOOTP="$(yq -r '.distro.partitions.boot' "$DISTRO_CONFIG")"
    local BOOTM="$ROOTM/boot"

    local HOMEP="$(yq -r '.distro.partitions.home' "$DISTRO_CONFIG")"
    local HOMEM="$ROOTM/home"

    local VARP="$(yq -r '.distro.partitions.var' "$DISTRO_CONFIG")"
    local VARM="$ROOTM/var"

    local TMPP="$(yq -r '.distro.partitions.tmp' "$DISTRO_CONFIG")"
    local TMPM="$ROOTM/tmp"

    local OPTP="$(yq -r '.distro.partitions.opt' "$DISTRO_CONFIG")"
    local OPTM="$ROOTM/opt"

    local USRLOCALP="$(yq -r '.distro.partitions.usrlocal' "$DISTRO_CONFIG")"
    local USRLOCALM="$ROOTM/usr/local"
    
    run "mount -v $ROOTP $ROOTM"

    if [[ $MODE == "efi" && $EFIP != "null" && $EFIM != 'null' ]]; then
       run "mkdir -pv $EFIM"
       run "mount -v $EFIP $EFIM"	
    fi

    if [[ $BOOTP != 'null' ]]; then
       run "mkdir -pv $BOOTM"
       run "mount -v $BOOTP $BOOTM"	
    fi

    if [[ $HOMEP != 'null' ]]; then
       run "mkdir -pv $HOMEM"
       run "mount -v $HOMEP $HOMEM"	
    fi

    if [[ $VARP != 'null' ]]; then
       run "mkdir -pv $VARM"
       run "mount -v $VARP $VARM"	
    fi

    if [[ $TMPP != 'null' ]]; then
       run "mkdir -pv $TMPM"
       run "mount -v $TMPP $TMPM"

       run "chmod -v 1777 $TMPM"
    fi

    if [[ $OPTP != 'null' ]]; then
       run "mkdir -pv $OPTM"
       run "mount -v $OPTP $OPTM"	
    fi

    if [[ $USRLOCALP != 'null' ]]; then
       run "mkdir -pv $USRLOCALM"
       run "mount -v $USRLOCALP $USRLOCALM"	
    fi
}

umount_sys() {
    run "umount -v -R $ROOTM/proc"
    run "umount -v -R $ROOTM/sys"
    run "umount -v -R $ROOTM/dev"
    run "umount -v -R $ROOTM/run"
}

mount_sys() { 
    # run "mount -v --types proc /proc $ROOTM/proc"
    # run "mount -v --rbind /sys $ROOTM/sys"
    # run "mount -v --make-rslave $ROOTM/sys"
    # run "mount -v --rbind /dev $ROOTM/dev"
    # run "mount -v --make-rslave $ROOTM/dev"
    # run "mount -v --rbind /run $ROOTM/run"
    # run "mount -v --make-slave $ROOTM/run"

    run "mount -v --bind /proc $ROOTM/proc"
    run "mount -v --bind /dev $ROOTM/dev"
    run "mount -v --bind /dev/pts $ROOTM/dev/pts"
    run "mount -v --bind /sys $ROOTM/sys"
    run "mount -v --bind /run $ROOTM/run"
    run "mount -v --bind /sys/firmware/efi/efivars $ROOTM/sys/firmware/efi/efivars"
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

