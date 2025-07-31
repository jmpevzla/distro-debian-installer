#!/bin/bash

if [[ ! -f "./installer.lock" ]]; then
    source ../helper.sh
    load_path
fi

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 4 ==="'
run 'echo ""'

if [[ ! -f "./installer.lock" ]]; then
    load_single
fi

run 'echo "$(yq '.distro.stages.s4.desc' "$DISTRO_CONFIG")"'

apt_update
croot 'apt remove -y --purge locales'

run 'echo ""'
run 'echo "Locales in config:"'
run 'echo ""'

readarray -t ITEMS < <(yq '.distro.config.locale.gen[]' "$DISTRO_CONFIG" | tr -d '\"')

LOCALES=""
for locale in "${ITEMS[@]}"; do
    run 'echo "$locale"'
    LOCALES+=" $locale,"
done
LOCALES="${LOCALES%?}"

DEFLOCALE="$(yq '.distro.config.locale.default' "$DISTRO_CONFIG" | tr -d '\"')"

run 'echo ""'
run 'echo "Set Default Locale: $DEFLOCALE"'

cat > "$ROOTM/tmp/locales_preseed.conf" << EOF
locales locales/locales_to_be_generated select $LOCALES
locales locales/default_environment_locale select $DEFLOCALE
EOF

croot 'debconf-set-selections /tmp/locales_preseed.conf'
croot 'apt install -y locales'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 4 ==="'
run 'echo ""'
