#!/bin/bash

source ./loader.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 11 ==="'
run 'echo ""'

stage_mount
info

run 'echo "$(yq '.distro.stages.s11.desc' "$DISTRO_CONFIG")"'

NAME="$(yq '.distro.name' "$DISTRO_CONFIG" | tr -d '\"')"
MODE="$(yq '.distro.mode' "$DISTRO_CONFIG" | tr -d '\"')"
EFI_TARGET="$(yq '.distro.config.efi_target' "$DISTRO_CONFIG" | tr -d '\"')"
GRUB_MBR="$(yq '.distro.config.grub_mbr' "$DISTRO_CONFIG" | tr -d '\"')"

apt_update

if [[ $MODE == "efi" ]]; then
    croot 'apt install -y grub-efi os-prober ntfs-3g'
    croot 'grub-install --efi-directory=/efi --target=$EFI_TARGET --bootloader-id=distro_$NAME'
else
    croot 'apt install -y grub-pc os-prober ntfs-3g'
    croot 'grub-install $GRUB_MBR'
fi

croot 'update-grub'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 11 ==="'
run 'echo ""'
