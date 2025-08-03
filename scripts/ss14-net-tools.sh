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
run 'echo "=== End Distro Installer - $FILE ==="'
run 'echo ""'
