#!/bin/bash

if [[ ! -f "./installer.lock" ]]; then
    source ../helper.sh
    load_path
fi

FILE=$(basename "$BASH_SOURCE")

run 'echo ""'
run 'echo "=== Begin Distro Installer - $FILE ==="'
run 'echo ""'

if [[ ! -f "./installer.lock" ]]; then
    umount_part
    mount_part
    run 'echo ""'
    info 
fi

get_desc "$FILE"

run 'genfstab -U $ROOTM > $ROOTM/etc/fstab'
run 'sed -i "/\/run/d" $ROOTM/etc/fstab'
run 'cat $ROOTM/etc/fstab'

run 'echo ""'
run 'echo "=== End Distro Installer - $FILE ==="'
run 'echo ""'
