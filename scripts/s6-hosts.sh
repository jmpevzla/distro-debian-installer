#!/bin/bash

source ./chroot.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 6 ==="'
run 'echo ""'

info

run 'echo "$(yq '.distro.stages.s6.desc' "$DISTRO_CONFIG")"'

ROOTM="$(yq '.distro.mount.root' "$DISTRO_CONFIG" | tr -d '\"')"
HOSTNAME="$(yq '.distro.config.hostname' "$DISTRO_CONFIG" | tr -d '\"')"

run 'echo "Set Hosts in /etc/hosts"'

cat > "$ROOTM"/etc/hosts << EOF
127.0.0.1       localhost $HOSTNAME
::1             localhost ip6-localhost ip6-loopback
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters
EOF

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 6 ==="'
run 'echo ""'
