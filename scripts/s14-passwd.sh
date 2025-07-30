#!/bin/bash

source ./loader.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 14 ==="'
run 'echo ""'

stage_mount
info

run 'echo "$(yq '.distro.stages.s14.desc' "$DISTRO_CONFIG")"'

PFILE="../.root.env"

if [[ -f "$PFILE" ]]; then
    croot 'passwd root < ../.root.env'
    echo -n "" > ../.root.env
else
    run 'echo ".root.env not exist!"'
fi

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 14 ==="'
run 'echo ""'
