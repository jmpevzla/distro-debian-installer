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

umount_sys
umount_part

shopt -s lastpipe
declare -i inte
values=()
yq '.distro.stages | keys[]' "$DISTRO_CONFIG" | tr -d '"' | while read -r stage_key; do
    inte=${stage_key:1}
    values+=(${inte})
done
printf "%i\n" "${values[@]}" | sort -n | readarray -t values

is_mount_part=0
is_mount_sys=0
for st in "${values[@]}"; do
    if [[ $st -ge 0 && $is_mount_part -eq 0 ]]; then
	mount_part
	is_mount_part=1
    fi
    if [[ $st -gt 1 && $is_mount_sys -eq 0 ]]; then
	mount_sys
	is_mount_sys=1
    fi
    key=".distro.stages.s$st.script"
    script="$(yq "$key" "$DISTRO_CONFIG" | tr -d '"')"
    echo "script: $script"
    source "./scripts/$script"
    
    # if [[ $st == 15 ]]; then
    # 	echo "script: $script"
    # 	source "./scripts/$script"
    # 	umount_sys
    # 	umount_part
    # 	unset values
    # 	rm -f installer.lock
    # 	exit
    # fi
done

umount_sys
umount_part
unset values
rm -f installer.lock
run 'echo ""'
run 'echo "=== End Distro Installer ==="'
run 'echo ""'
