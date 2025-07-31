#!/bin/bash

if [[ ! -f "./installer.lock" ]]; then
    source ../helper.sh
    load_path
fi

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 22 ==="'
run 'echo ""'

if [[ ! -f "./installer.lock" ]]; then
    load_single
fi

run 'echo "$(yq '.distro.stages.s22.desc' "$DISTRO_CONFIG")"'

apt_update
croot 'apt install -y curl speedtest-cli ranger mc aria2 ncdu zoxide tealdeer eza'

# Weather viewer
cat > $ROOTM/usr/local/bin/wttr <<EOF
#!/bin/bash

curl wttr.in

EOF
chmod +x $ROOTM/usr/local/bin/wttr

# Maps viewer
cat > $ROOTM/usr/local/bin/mapscii <<EOF
#!/bin/bash

telnet mapscii.me

EOF
chmod +x $ROOTM/usr/local/bin/mapscii

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 22 ==="'
run 'echo ""'
