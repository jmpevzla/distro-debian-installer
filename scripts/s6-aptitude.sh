#!/bin/bash

source ./loader.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 6 ==="'
run 'echo ""'

stage_mount
info

run 'echo "$(yq '.distro.stages.s6.desc' "$DISTRO_CONFIG")"'

apt_update
croot 'apt install -y aptitude'
croot 'aptitude install -y "?priority(standard)"'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 6 ==="'
run 'echo ""'
