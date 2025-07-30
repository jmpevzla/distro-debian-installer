#!/bin/bash

source ./chroot.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 3 ==="'
run 'echo ""'

info

run 'echo "$(yq '.distro.stages.s3.desc' "$DISTRO_CONFIG")"'

AREA="$(yq '.distro.config.tz.area' "$DISTRO_CONFIG" | tr -d '\"')"
ZONE="$(yq '.distro.config.tz.zone' "$DISTRO_CONFIG" | tr -d '\"')"

run 'echo "Set Timezone to $TZ in /etc/localtime & /etc/timezone"'

cat << EOF > "$ROOTM"/tmp/tzdata_preseed.conf
tzdata tzdata/Areas select $AREA
tzdata tzdata/Zones/$AREA select $ZONE
EOF

croot 'rm -f /etc/localtime /etc/timezone'
croot 'debconf-set-selections /tmp/tzdata_preseed.conf'
croot 'dpkg-reconfigure -f noninteractive tzdata'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 3 ==="'
run 'echo ""'
