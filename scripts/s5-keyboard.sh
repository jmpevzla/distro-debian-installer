#!/bin/bash

if [[ ! -f "./installer.lock" ]]; then
    source ../helper.sh
    load_path
fi

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 5 ==="'
run 'echo ""'

if [[ ! -f "./installer.lock" ]]; then
    load_single
fi

run 'echo "$(yq '.distro.stages.s5.desc' "$DISTRO_CONFIG")"'

apt_update
croot 'apt autoremove -y --purge console-setup'

run 'echo ""'
VARIANT="$(yq '.distro.config.keyboard.variant' "$DISTRO_CONFIG" | tr -d '\"')"
VARIANTCODE="$(yq '.distro.config.keyboard.variantcode' "$DISTRO_CONFIG" | tr -d '\"')"
XKBKEYMAP="$(yq '.distro.config.keyboard."xkb-keymap"' "$DISTRO_CONFIG" | tr -d '\"')"
LAYOUT="$(yq '.distro.config.keyboard.layout' "$DISTRO_CONFIG" | tr -d '\"')"
LAYOUTCODE="$(yq '.distro.config.keyboard.layoutcode' "$DISTRO_CONFIG" | tr -d '\"')"
MODELCODE="$(yq '.distro.config.keyboard.modelcode' "$DISTRO_CONFIG" | tr -d '\"')"

run 'echo "Set Keyboard with values:"'
run 'echo "Layout: $LAYOUT"'
run 'echo "Layout Code: $LAYOUTCODE"'
run 'echo "xkb-keymap: $XKBKEYMAP"'
run 'echo "Variant: $VARIANT"'
run 'echo "Variant Code: $VARIANTCODE"'
run 'echo "Model Code: $MODELCODE"'
run 'echo ""'

cat << EOF > "$ROOTM"/tmp/keyboard-preseed.conf
keyboard-configuration keyboard-configuration/variantcode string $VARIANTCODE
keyboard-configuration keyboard-configuration/variant select $VARIANT
keyboard-configuration keyboard-configuration/layout select $LAYOUT
keyboard-configuration keyboard-configuration/layoutcode string $LAYOUTCODE
keyboard-configuration keyboard-configuration/xkb-keymap string $XKBKEYMAP
keyboard-configuration keyboard-configuration/modelcode string $MODELCODE
keyboard-configuration keyboard-configuration/compose select No compose key
keyboard-configuration keyboard-configuration/toggle select No toggling
keyboard-configuration keyboard-configuration/ctrl_alt_bksp boolean false
keyboard-configuration keyboard-configuration/altgr select The default for the keyboard layout
keyboard-configuration keyboard-configuration/switch select No temporary switch
EOF

cat << EOF > "$ROOTM"/tmp/console-preseed.conf
console-setup console-setup/codesetcode string Lat15
console-setup console-setup/codeset47 select # Latin1 and Latin5 - western Europe and Turkic languages
console-setup console-setup/fontsize-text47 string 8x16
console-setup console-setup/fontsize select 8x16
console-setup console-setup/use_system_font boolean false
console-setup console-setup/charmap47 select UTF-8
console-setup console-setup/framebuffer_only boolean false
console-setup console-setup/fontface47 select Fixed
console-setup console-setup/guess_font boolean false
console-setup console-setup/store_defaults_in_debconf_db boolean true
console-setup console-setup/fontsize-fb47 string 8x16
EOF

croot 'debconf-set-selections /tmp/keyboard-preseed.conf'
croot 'debconf-set-selections /tmp/console-preseed.conf'

croot 'apt install -y console-setup'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 5 ==="'
run 'echo ""'
