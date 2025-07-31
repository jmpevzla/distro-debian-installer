#!/bin/bash

if [[ ! -f "./installer.lock" ]]; then
    source ../helper.sh
    load_path
fi

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 13 ==="'
run 'echo ""'

if [[ ! -f "./installer.lock" ]]; then
    load_single
fi

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
