#!/bin/bash

source ./chroot.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 3 ==="'
run 'echo ""'

info

run 'echo "$(yq '.distro.stages.s3.desc' "$DISTRO_CONFIG")"'

RTC="$(yq '.distro.config.rtc' "$DISTRO_CONFIG" | tr -d '\"')"

if [[ "$RTC" == "LOCAL" ]]; then
    run 'echo "Set /etc/adjtime to localtime in /etc/adjtime"'
    croot 'hwclock --systohc --localtime'
else
    run 'echo "Set /etc/adjtime to UTC in /etc/adjtime"'
    croot 'hwclock --systohc --utc'
fi

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 3 ==="'
run 'echo ""'
