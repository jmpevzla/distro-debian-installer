#!/bin/bash

source ./apt.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 8 ==="'
run 'echo ""'

info

run 'echo "$(yq '.distro.stages.s8.desc' "$DISTRO_CONFIG")"'

ROOTM="$(yq '.distro.mount.root' "$DISTRO_CONFIG" | tr -d '\"')"

run 'echo ""'
run 'echo "Locales in config:"'
run 'echo ""'

readarray -t ITEMS < <(yq '.distro.config.locale.gen[]' "$DISTRO_CONFIG" | tr -d '\"')

# For each locale, uncomment the line in the locale.gen file.
for locale in "${ITEMS[@]}"; do
    run 'echo "$locale"'
    escaped_locale=$(echo "$locale" | sed 's/[\/&.]/\\&/g')
    sed -i "s/^#\s*${escaped_locale}/${escaped_locale}/" "$ROOTM/etc/locale.gen"
done

croot 'locale-gen'

run 'echo ""'
run 'echo "Set Default Locale"'

DEFLOCALE="$(yq '.distro.config.locale.default' "$DISTRO_CONFIG")"

cat > "$ROOTM/etc/locale.conf" << EOF
LANGUAGE=$DEFLOCALE,
LC_ALL=$DEFLOCALE,
LC_CTYPE=$DEFLOCALE,
LC_NUMERIC=$DEFLOCALE,
LC_COLLATE=$DEFLOCALE,
LC_TIME=$DEFLOCALE,
LC_MESSAGES=$DEFLOCALE,
LC_MONETARY=$DEFLOCALE,
LC_ADDRESS=$DEFLOCALE,
LC_IDENTIFICATION=$DEFLOCALE,
LC_MEASUREMENT=$DEFLOCALE,
LC_PAPER=$DEFLOCALE,
LC_TELEPHONE=$DEFLOCALE,
LC_NAME=$DEFLOCALE,
LANG=$DEFLOCALE
EOF

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 8 ==="'
run 'echo ""'
