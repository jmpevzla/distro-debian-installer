#!/bin/bash

source ./loader.sh

ROOTM="$(yq '.distro.mount.root' "$DISTRO_CONFIG" | tr -d '\"')"

umount -v $ROOTM/sys/firmware/efi/efivars
umount -v $ROOTM/proc
umount -v $ROOTM/sys
umount -v $ROOTM/dev

source ./ps-mount.sh

mount -v --bind /dev $ROOTM/dev
mount -v --bind /sys $ROOTM/sys
mount -v --bind /proc $ROOTM/proc
mount -v -t efivarfs none $ROOTM/sys/firmware/efi/efivars

croot() {
    run "chroot $ROOTM" "$@"
}
