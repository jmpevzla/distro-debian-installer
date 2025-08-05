#!/bin/bash

source ./helper.sh

dconfig "."
dlog "."

rootm

run 'echo ""'
run 'echo "=== Begin Distro Installer ==="'
run 'echo ""'

if [[ -f ./installer.lock  ]]; then
    echo "Check that another instance is not running, and delete the installer.lock file."
    echo ""
    exit
fi

touch installer.lock
shopt -s lastpipe

umount_sys
umount_part

run 'echo ""'
mount_part
is_sys_mounted=0
yq -r '.distro.stages[] | .script, .desc' "$DISTRO_CONFIG" | while IFS= read -r script && IFS= read -r desc; do
    if [[ $script != "ss0-bootstrap.sh" && $is_sys_mounted == 0 ]]; then
	mount_sys
	is_sys_mounted=1
    fi

    # run 'echo "script: $script"'
    source "./scripts/$script"
done

umount_sys
umount_part
rm -f installer.lock
run 'echo ""'
run 'echo "=== End Distro Installer ==="'
run 'echo ""'
