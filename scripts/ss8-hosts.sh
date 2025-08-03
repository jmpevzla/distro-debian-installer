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
fi

get_desc "$FILE"

HOSTNAME="$(yq '.distro.config.hostname' "$DISTRO_CONFIG" | tr -d '\"')"

run 'echo "Set Hosts in /etc/hosts"'

cat > "$ROOTM"/etc/hosts << EOF
127.0.0.1       localhost $HOSTNAME
::1             localhost ip6-localhost ip6-loopback
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters
EOF

run 'echo ""'
run 'echo "=== End Distro Installer - $FILE ==="'
run 'echo ""'
