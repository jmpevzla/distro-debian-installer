#!/bin/bash

source ./apt.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 7 ==="'
run 'echo ""'

info

run 'echo "$(yq '.distro.stages.s7.desc' "$DISTRO_CONFIG")"'

ROOTM="$(yq '.distro.mount.root' "$DISTRO_CONFIG" | tr -d '\"')"
VERSION="$(yq '.distro.version' "$DISTRO_CONFIG" | tr -d '\"')"
REPO="$(yq '.distro.config.repo' "$DISTRO_CONFIG" | tr -d '\"')"

run 'echo "Set apt sources in /etc/apt/sources.list"'

cat > "$ROOTM"/etc/apt/sources.list << EOF
deb $REPO $VERSION main contrib non-free non-free-firmware
#deb-src $REPO $VERSION main contrib non-free non-free-firmware

deb https://security.debian.org/debian-security $VERSION-security main contrib non-free non-free-firmware
#deb-src https://security.debian.org/debian-security $VERSION-security main contrib non-free non-free-firmware

deb $REPO $VERSION-updates main contrib non-free non-free-firmware
#deb-src $REPO $VERSION-updates main contrib non-free non-free-firmware

deb $REPO $VERSION-backports main contrib non-free non-free-firmware
#deb-src $REPO $VERSION-backports main contrib non-free non-free-firmware

EOF

apt_update

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 7 ==="'
run 'echo ""'
