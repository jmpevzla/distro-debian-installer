#!/bin/bash

if [[ ! -f "./installer.lock" ]]; then
    source ../helper.sh
    load_path
fi

FILE=$(basename "$BASH_SOURCE")

run 'echo ""'
run 'echo "=== Begin Distro Installer - $FILE ==="'
run 'echo ""'

if [[ ! -f "./installer.lock" ]]; then
    load_single
    PFILE="../.root.env"
else
    PFILE="./.root.env"
fi

get_desc "$FILE"

if [[ -f "$PFILE" ]]; then
    croot 'passwd root < $PFILE'
    echo -n "" > $PFILE
else
    run 'echo ".root.env not exist!"'
fi

run 'echo ""'
run 'echo "=== End Distro Installer - $FILE ==="'
run 'echo ""'
