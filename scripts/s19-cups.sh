#!/bin/bash

if [[ ! -f "./installer.lock" ]]; then
    source ../helper.sh
    load_path
fi

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 19 ==="'
run 'echo ""'

if [[ ! -f "./installer.lock" ]]; then
    load_single
fi

run 'echo "$(yq '.distro.stages.s19.desc' "$DISTRO_CONFIG")"'

apt_update
croot 'apt install -y cups cups-client printer-driver-gutenprint'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 19 ==="'
run 'echo ""'
