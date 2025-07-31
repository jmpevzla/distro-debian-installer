#!/bin/bash

source ./loader.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 19 ==="'
run 'echo ""'

stage_mount
info

run 'echo "$(yq '.distro.stages.s19.desc' "$DISTRO_CONFIG")"'

apt_update
croot 'apt install -y cups cups-client printer-driver-gutenprint'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 19 ==="'
run 'echo ""'
