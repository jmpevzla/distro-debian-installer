#!/bin/bash

if [[ ! -f "./installer.lock" ]]; then
    source ../helper.sh
    load_path
fi

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 15 ==="'
run 'echo ""'

if [[ ! -f "./installer.lock" ]]; then
    load_single
    PFILE="../.user.env"
else
    PFILE="./.user.env"
fi

run 'echo "$(yq '.distro.stages.s15.desc' "$DISTRO_CONFIG")"'

apt_update
croot 'apt install -y sudo'

USER="$(yq '.distro.config.user' "$DISTRO_CONFIG" | tr -d '\"')"

if [[ -f "$PFILE" ]]; then
    croot 'useradd -m -G users,sudo,audio,video,plugdev -s /bin/bash $USER'
    croot 'passwd $USER < $PFILE'
    echo -n "" > $PFILE

    croot 'cp /etc/sudoers /etc/sudoers.bak'
    sed -i -E "s/^#\s*%sudo\s+ALL=\(ALL(:ALL)?\)\s+ALL$/%sudo ALL=(ALL:ALL) ALL/" "$ROOTM/etc/sudoers"
    sed -i -E 's/^(Defaults\s*env_reset)$/\1,pwfeedback/' "$ROOTM/etc/sudoers"
else
    run 'echo ".user.env not exist!"'
fi

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 15 ==="'
run 'echo ""'
