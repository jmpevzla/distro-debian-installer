#!/bin/bash

source ./chroot.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 4 ==="'
run 'echo ""'

info

run 'echo "$(yq '.distro.stages.s4.desc' "$DISTRO_CONFIG")"'

TZ="$(yq '.distro.config.tz' "$DISTRO_CONFIG" | tr -d '\"')"

run 'echo "Set Timezone to $TZ in /etc/localtime"'
croot 'ln -sf ../usr/share/zoneinfo/"$TZ" /etc/localtime'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 4 ==="'
run 'echo ""'
