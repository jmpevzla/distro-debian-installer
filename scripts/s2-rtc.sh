#!/bin/bash

if [[ ! -f "./installer.lock" ]]; then
    source ../helper.sh
    load_path
fi

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 2 ==="'
run 'echo ""'

if [[ ! -f "./installer.lock" ]]; then
    load_single
fi

run 'echo "$(yq '.distro.stages.s2.desc' "$DISTRO_CONFIG")"'

apt_update
croot 'apt install -y util-linux-extra'

RTC="$(yq '.distro.config.rtc' "$DISTRO_CONFIG" | tr -d '\"')"

if [[ "$RTC" == "LOCAL" ]]; then
    run 'echo "Set to localtime in /etc/adjtime"'
    croot 'hwclock --systohc --localtime'
else
    run 'echo "Set to UTC in /etc/adjtime"'
    croot 'hwclock --systohc --utc'
fi

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 2 ==="'
run 'echo ""'
