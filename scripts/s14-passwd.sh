#!/bin/bash

if [[ ! -f "./installer.lock" ]]; then
    source ../helper.sh
    load_path
fi

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 14 ==="'
run 'echo ""'

if [[ ! -f "./installer.lock" ]]; then
    load_single
    PFILE="../.root.env"
else
    PFILE="./.root.env"
fi

run 'echo "$(yq '.distro.stages.s14.desc' "$DISTRO_CONFIG")"'

if [[ -f "$PFILE" ]]; then
    croot 'passwd root < $PFILE'
    echo -n "" > $PFILE
else
    run 'echo ".root.env not exist!"'
fi

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 14 ==="'
run 'echo ""'
