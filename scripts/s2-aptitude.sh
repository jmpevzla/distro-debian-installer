#!/bin/bash

source ./apt.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 2 ==="'
run 'echo ""'

info

run 'echo "$(yq '.distro.stages.s2.desc' "$DISTRO_CONFIG")"'

apt_update
croot 'apt install -y aptitude'
croot 'aptitude install -y "?priority(standard)"'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 2 ==="'
run 'echo ""'
