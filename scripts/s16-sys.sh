#!/bin/bash

source ./loader.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 16 ==="'
run 'echo ""'

stage_mount
info

run 'echo "$(yq '.distro.stages.s16.desc' "$DISTRO_CONFIG")"'

apt_update
croot 'apt install -y curl git build-essential alsa-utils pipewire wireplumber pipewire-pulse gawk ufw dosfstools rsync'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 16 ==="'
run 'echo ""'
