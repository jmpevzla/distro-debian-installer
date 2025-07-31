#!/bin/bash

if [[ ! -f "./installer.lock" ]]; then
    source ../helper.sh
    load_path
fi

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 23 ==="'
run 'echo ""'

if [[ ! -f "./installer.lock" ]]; then
    load_single
fi

run 'echo "$(yq '.distro.stages.s23.desc' "$DISTRO_CONFIG")"'

apt_update
croot 'apt install -y mutt duf fdupes procs micro khal newsboat taskwarrior figlet'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 23 ==="'
run 'echo ""'
