#!/bin/bash

source ./loader.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 13 ==="'
run 'echo ""'

stage_mount
info

run 'echo "$(yq '.distro.stages.s13.desc' "$DISTRO_CONFIG")"'

apt_update

croot 'apt install -y net-tools dhcpcd network-manager'

cat > $ROOTM/etc/NetworkManager/NetworkManager.conf <<EOF
[main]
plugins=ifupdown,keyfile
dhcp=dhcpcd

[ifupdown]
managed=false
EOF

croot 'systemctl disable dhcpcd'
croot 'systemctl enable NetworkManager'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 13 ==="'
run 'echo ""'
